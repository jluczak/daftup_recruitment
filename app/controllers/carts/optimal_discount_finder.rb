# frozen_string_literal: true

module Carts
  class OptimalDiscountFinder
    def call
      best_choice = find_optimal_combination
      sets = []
      extras = []
      best_choice['used_discounts'].each do |discount|
        discount.kind == 'set' ? sets << discount : extras << discount
      end
      [sets, extras, best_choice['regular_price'],
       best_choice['regular_price_products'], best_choice['sum']]
    end

    private

    def count_total_no_discount(items_left)
      items_left.inject(0) { |sum, item| sum + item.quantity * item.product.price }
    end

    def array_common(first_array, second_array)
      (first_array & second_array).flat_map { |n| [n] * [first_array.count(n), second_array.count(n)].min }
    end

    def delete_product_from_cart(items_left, product_id)
      item = items_left.select { |item| item.product_id == product_id }.first
      if item.quantity == 1
        items_left.delete(item)
      else
        item.quantity -= 1
      end
    end

    def add_product_to_cart(items_left, product_id)
      item = items_left.select { |item| item.product_id == product_id }.first
      if item
        item.quantity += 1
      else
        items_left << Item.new(product_id: product_id)
      end
    end

    def use_set_discount(items_left, discount, used_discounts, sum)
      product_ids = []
      items_left.map { |item| item.quantity.times { product_ids << item.product_id } }
      if (discount.product_ids - product_ids).empty?
        product_ids = product_ids.array_difference(discount.product_ids)
        used_discounts << discount
        discount.product_ids.each do |product_id|
          delete_product_from_cart(items_left, product_id)
        end
        sum += discount.price
      else
        products_got = array_common(discount.product_ids, product_ids)
        if discount.price < products_got.inject(0) { |sum, x| sum + Product.find(x).price }
          products_needed = discount.product_ids.array_difference(products_got)
          products_needed.each do |product_id|
            add_product_to_cart(items_left, product_id)
          end
          product_ids = product_ids.array_difference(discount.product_ids)
          used_discounts << discount
          discount.product_ids.each do |product_id|
            delete_product_from_cart(items_left, product_id)
          end
          sum += discount.price
        end
      end
      [items_left, used_discounts, sum]
    end

    def use_extra_discount(items_left, discount, used_discounts, sum)
      items = items_left.select { |item| discount.product_ids.include?(item.product_id) }
      items.each do |item|
        lowest_count = item.product.discounts.extra.lowest_count.count
        item.quantity += 1 if item.quantity % (lowest_count + 1) == lowest_count
        times_used = item.quantity / (lowest_count + 1)
        times_used.times { used_discounts << discount }
        (times_used * (lowest_count + 1)).times { delete_product_from_cart(items_left, item.product_id) }
        (times_used * lowest_count).times { sum += item.product.price }
      end
      [items_left, used_discounts, sum]
    end

    def find_optimal_combination
      best_choice = {}
      possible_discounts = []

      all_items = Item.all
      sets = []
      extras = []
      all_items.each do |item|
        item.product.discounts.each do |discount|
          discount.kind == 'set' ? sets << discount : extras << discount
        end
      end
      possible_discounts = sets + extras.uniq

      regular_price = count_total_no_discount(all_items)
      best_choice['sum'] = regular_price
      best_choice['used_discounts'] = []
      best_choice['regular_price_products'] = all_items.map(&:product)

      if possible_discounts.any?
        discount_combinations = possible_discounts.permutation.to_a.uniq
        items_without_discounts = all_items.select { |item| item.product.discounts.empty? }
        discount_combinations.each do |combination|
          items_left = Item.all.select { |item| item.product.discounts.any? }
          sum = 0.00
          possible_discounts = []
          used_discounts = []
          combination.each do |discount|
            next unless items_left.any?

            items_left, used_discounts, sum =
              if discount.kind == 'extra'
                use_extra_discount(items_left, discount, used_discounts, sum)
              else
                use_set_discount(items_left, discount, used_discounts, sum)
            end
          end
          sum += count_total_no_discount(items_without_discounts + items_left)
          regular_price_products = (items_without_discounts + items_left).map(&:product)

          next unless sum < best_choice['sum']

          best_choice['sum'] = sum.round(2)
          best_choice['used_discounts'] = used_discounts
          best_choice['regular_price_products'] = regular_price_products
          best_choice['regular_price'] = regular_price
        end
      end
      best_choice
    end
  end
end

class Array
  def array_difference(other)
    h = other.each_with_object(Hash.new(0)) { |e, h| h[e] += 1 }
    reject { |e| h[e] > 0 && h[e] -= 1 }
  end
end

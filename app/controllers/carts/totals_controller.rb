module Carts
  class TotalsController < ApplicationController
    def show
      com = find_optimal_combination()
      render json: com.key(com.values.min)
    end

    def count_total_no_discount(items_left)
      items_left.inject(0){ |sum,item| sum + item.quantity * item.product.price }
    end

    def array_common(first_array, second_array)
      (first_array & second_array).flat_map { |n| [n]*[first_array.count(n), second_array.count(n)].min }
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
        items_left << Item.new(product_id:product_id)
      end
    end

    def use_set_discount(items_left, discount, used_discounts, sum)
      product_ids = []
      items_left.map{|item| (item.quantity).times {product_ids << item.product_id} }
      if (discount.product_ids - product_ids).empty?
        product_ids = product_ids.array_difference(discount.product_ids)
        used_discounts << discount
        discount.product_ids.each{ |product_id|
          delete_product_from_cart(items_left, product_id)}
        sum += discount.price
      else
        products_got = array_common(discount.product_ids, product_ids)
        if discount.price < products_got.inject(0){|sum,x| sum + Product.find(x).price}
          products_needed = discount.product_ids.array_difference(products_got)
          products_needed.each{ |product_id|
            add_product_to_cart(items_left, product_id)
          }
          product_ids = product_ids.array_difference(discount.product_ids)
          used_discounts << discount
          discount.product_ids.each{ |product_id|
            delete_product_from_cart(items_left, product_id)}
          sum += discount.price
        end
      end
      [items_left, used_discounts, sum]
    end

    def use_extra_discount(items_left, discount, used_discounts, sum)
      items = items_left.select{ |item| discount.product_ids.include?(item.product_id)}
      items.each{ |item|
        lowest_count = item.product.discounts.extra.lowest_count.count
        if item.quantity % (lowest_count+1) == lowest_count
          item.quantity +=1
        end
        times_used = item.quantity/(lowest_count+1)
        times_used.times { used_discounts << discount }
        (times_used*(lowest_count+1)).times { delete_product_from_cart(items_left, item.product_id) }
        (times_used*lowest_count).times { sum += item.product.price }
      }
      [items_left, used_discounts, sum]
    end

    def find_optimal_combination()
      combination_sums = {}
      possible_discounts = []

      all_items = Item.all.to_a
      # all_items.all.map{|item| item.product.discounts.each{|discount| possible_discounts << discount}}
      sets, extras = [], []
      all_items.each{|item|
        item.product.discounts.each{|discount|
          discount.kind == "set" ? sets << discount : extras << discount}}
      possible_discounts = sets + extras.uniq

      combination_sums["no discounts"] = count_total_no_discount(all_items)
      if possible_discounts.any?
        discount_combinations = possible_discounts.permutation.to_a.uniq
        # items_with_discounts = Item.all.to_a.select{ |item| item.product.discounts.any?}
        items_without_discounts = all_items.select{ |item| item.product.discounts.empty?}
        discount_combinations.each{|combination|
          items_left = Item.all.to_a.select{ |item| item.product.discounts.any?}
          sum = 0.00
          possible_discounts = []
          used_discounts = []
          combination.each{|discount|
            if items_left.any?
              items_left, used_discounts, sum =
                if discount.kind == "extra"
                  use_extra_discount(items_left, discount, used_discounts, sum)
                else
                  use_set_discount(items_left, discount, used_discounts, sum)
              end
            end
          }
          sum += count_total_no_discount(items_without_discounts + items_left)
          combination_sums[used_discounts] = sum
        }
      end
      combination_sums
    end
  end
end

class Array
  def array_difference(other)
    h = other.each_with_object(Hash.new(0)) { |e,h| h[e] += 1 }
    reject { |e| h[e] > 0 && h[e] -= 1 }
  end
end

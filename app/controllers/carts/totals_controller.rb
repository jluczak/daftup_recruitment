# frozen_string_literal: true

module Carts
  class TotalsController < ApplicationController
    def show
      sets, extras, no_discounts, regular_products, price_with_discounts = OptimalDiscountFinder.new.call
      render json: {
        sets: serialized_collection(sets, DiscountSerializer),
        extras: serialized_collection(extras, DiscountSerializer),
        regular_price: no_discounts,
        regular_products: serialized_collection(regular_products, DiscountSerializer),
        price_with_discounts: price_with_discounts
      }
    end
  end
end

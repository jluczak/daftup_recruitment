module Carts
  class DiscountsController < ApplicationController
    def create
      Discount.create(discount_params)
      render_response(status = :success)
    end

    def update
      discount = Discount.find(params[:id])
      discount.update(discount_params)
      render_response
    end

    private

    def discount_params
      params.permit(:kind, :name, :count, :price, product_ids:[])
    end

    def render_response(status = :success)
      render json: {
         items: serialized_collection(Item.all, ItemSerializer),
         discounts: serialized_collection(Discount.all, DiscountSerializer),
      }, status: status
    end
  end
end

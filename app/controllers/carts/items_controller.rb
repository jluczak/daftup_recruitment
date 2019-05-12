module Carts
  class ItemsController < ApplicationController
    def create
      item = Item.find_by(product_id: params[:product_id])
      item.present? ? item.increase_quantity(params[:quantity].to_i) : Item.create!(item_params)
      render_response(:created)
    end

    def update
      item = Item.find(params[:id])
      item.update(item_params)
      render_response
    end

    private

    def item_params
      params.permit(:quantity, :product_id)
    end

    def render_response(status = :ok)
      render json: {
         items: serialized_collection(Item.all, ItemSerializer),
         discounts: serialized_collection(Discount.all, DiscountSerializer),
      }, status: status
    end
  end
end

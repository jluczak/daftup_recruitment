module Carts
  class ItemsController < ApplicationController
    def create
      item = Item.find_by(product_id: params[:product_id])
      item.present? ? item.increase_quantity(params[:quantity]) : Item.create(item_params)
      render_response
    end

    def update
      item = Item.find(params[:id])
      item.update(item_params)
      render_response
    end

    private

    def item_params
      params.require(:item).permit(:quantity, :product_id)
    end

    def render_response
      render json: {
         items: ActiveModel::Serializer::CollectionSerializer.new(Item.all, each_serializer: ItemSerializer),
         discounts: ActiveModel::Serializer::CollectionSerializer.new(Discount.all, each_serializer: DiscountSerializer),
      }
    end
  end
end

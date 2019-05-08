module Carts
  class ItemsController < ApplicationController
    def create
      item = Item.find_by(product_id: params[:product_id])
      if item.present?
        item.update_attribute(:quantity, item.quantity +=1 )
      else
        Item.create!(item_params)
      end
      render_response
    end

    def update
      item = Item.find(params[:id])
      item.update!(item_params)

      render_response
    end

    private

    def item_params
      params.permit(:quantity, :product_id)
    end

    def render_response
      render json: {
         items: ActiveModel::Serializer::CollectionSerializer.new(Item.all, each_serializer: ItemSerializer),
         discounts: ActiveModel::Serializer::CollectionSerializer.new(Discount.all, each_serializer: DiscountSerializer),
      }
    end
  end
end

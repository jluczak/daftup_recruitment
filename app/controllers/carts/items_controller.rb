module Carts
  class ItemsController < ApplicationController
    def create
      item = Item.find_by(product_id: params[:product_id])
      if item.present?
        item.update_attribute(:quantity, item.quantity +=1 )
      else
        Item.create!(item_params)
      end
      render json: Item.all, status: 201
    end

    def update
      item = Item.find_by(id: params[:id])
      item.update!(item_params)

      render json: Item.all
    end

    private

    def item_params
      params.permit(:quantity, :product_id)
    end
  end
end

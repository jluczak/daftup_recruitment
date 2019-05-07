class ItemsController < ApplicationController
  def create
    item = Item.create!(item_params)
    render json: item.to_json, status: 201
  end

  def update
    item.update!(item_params)

    render json: item.to_json
  end

  private

  def item_params
    params.permit(:quantity, :product)
  end
end

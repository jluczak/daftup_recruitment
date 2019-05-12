# frozen_string_literal: true

class CreateJoinTableProductDiscount < ActiveRecord::Migration[5.2]
  def change
    create_join_table :products, :discounts do |t|
      t.index %i[product_id discount_id]
      t.index %i[discount_id product_id]
    end
  end
end

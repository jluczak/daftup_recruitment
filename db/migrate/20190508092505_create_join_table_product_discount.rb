class CreateJoinTableProductDiscount < ActiveRecord::Migration[5.2]
  def change
    create_join_table :products, :discounts do |t|
      t.index [:product_id, :discount_id]
      t.index [:discount_id, :product_id]
    end
  end
end

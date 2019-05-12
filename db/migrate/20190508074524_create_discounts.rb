# frozen_string_literal: true

class CreateDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :discounts do |t|
      t.string :kind
      t.string :name
      t.float :price
      t.integer :count

      t.timestamps
    end
  end
end

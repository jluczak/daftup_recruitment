class CreateDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :discounts do |t|
      t.string :kind
      t.string :name
      t.decimal :price, precision: 12, scale: 3
      t.integer :count

      t.timestamps
    end
  end
end

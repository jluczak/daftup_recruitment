class Item < ApplicationRecord
  validates :product_id, uniqueness: true
  belongs_to :product

  def increase_quantity(amount)
    update_attribute(:quantity, self.quantity += amount || 1)
  end
end

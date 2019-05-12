class Item < ApplicationRecord
  validates :product_id, uniqueness: true
  validates :quantity, numericality: { only_integer: true, :greater_than_or_equal_to => 0 }
  belongs_to :product

  def increase_quantity(amount)
    update_attribute(:quantity, self.quantity += amount || 1)
  end
end

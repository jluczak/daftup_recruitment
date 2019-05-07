class Product < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  has_many  :items
end

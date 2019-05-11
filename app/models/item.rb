class Item < ApplicationRecord
  validates :product_id, uniqueness: true
  belongs_to :product
end

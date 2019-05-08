class Discount < ApplicationRecord
  KINDS = %w[set extra].freeze
  validates :kind, inclusion: { in: KINDS }
  validate :count_or_price?
  has_and_belongs_to_many :products
  validates :products, presence: true

  private

  def count_or_price?
    return if kind == "set" && count == nil || kind == "extra" && price == nil

    errors.add(:kind, :invalid, message: "invalid combination for set or extra")
  end
end

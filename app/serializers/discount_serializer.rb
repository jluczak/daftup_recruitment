# frozen_string_literal: true

class DiscountSerializer < ActiveModel::Serializer
  attributes :id, :kind, :product_ids, :name
  attribute :price, if: :set?
  attribute :count, if: :extra?

  def set?
    object.kind == 'set'
  end

  def extra?
    object.kind == 'extra'
  end
end

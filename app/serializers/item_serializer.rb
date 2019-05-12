# frozen_string_literal: true

class ItemSerializer < ActiveModel::Serializer
  attributes :id, :quantity
  belongs_to :product
end

# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    quantity { 5 }
    association :product
  end
end

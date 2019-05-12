# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    sequence :name do |n|
      "product#{n}"
    end
    price { 39.99 }
  end
end

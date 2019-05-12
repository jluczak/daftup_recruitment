FactoryBot.define do
  factory :item do
    quantity { 5 }
    association :product
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :discount do
    name { 'Three for two' }
    kind { 'extra' }
    count { 2 }
    products { [FactoryBot.create(:product)] }
  end
end

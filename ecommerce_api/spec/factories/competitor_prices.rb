FactoryBot.define do
  factory :competitor_price do
    association :product, factory: :product
    price { Money.new(Faker::Commerce.price(range: 100..10_000) * 100, "USD") }
  end
end

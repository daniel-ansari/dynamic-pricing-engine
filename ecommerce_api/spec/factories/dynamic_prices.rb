FactoryBot.define do
  factory :dynamic_price do
    price { Money.new(Faker::Commerce.price(range: 100..10_000) * 100, "USD") }
    association :product, factory: :product
  end
end

FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    qty { Faker::Number.between(from: 1, to: 100) } # Random quantity greater than 0
    default_price { Money.new(Faker::Commerce.price(range: 100..10_000) * 100, "USD") } # Random price in cents

    association :category, factory: :category
  end
end

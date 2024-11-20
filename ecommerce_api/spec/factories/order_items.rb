FactoryBot.define do
  factory :order_item do
    association :product, factory: :product
    quantity { Faker::Number.between(from: 1, to: 10) }
    price { product.default_price }
  end
end

FactoryBot.define do
  factory :order do
    total_price { Money.new(0, "USD") }
    total_quantity { 0 }
  end
end

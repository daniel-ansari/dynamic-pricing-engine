require 'rails_helper'

RSpec.describe Strategies::DemandPricingStrategy do
  let(:product) { create(:product, default_price: Money.new(1000), qty: 500) } # $10.00 default price
  let!(:order) { create(:order, status: :completed) }
  let!(:order_items) { create_list(:order_item, 11, order: order, product: product, price: product.price, quantity: 10) } # $10.00 default price
  let(:thirty_days_from_now) { 31.days.from_now }

  describe '#update_price' do
    it 'increases price when demand is high' do
      strategy = described_class.new(product)

      updated_price = strategy.update_price(Money.new(1000)) # $10.00 initial price

      expect(updated_price).to eq(Money.new(1050)) # $10.50 after 5% increase
    end

    it 'does not change price when demand is not high in next 30 days' do
      Timecop.freeze(thirty_days_from_now) do
        strategy = described_class.new(product)
        updated_price = strategy.update_price(Money.new(1000))

        expect(updated_price).to eq(Money.new(1000)) # No change
      end
    end
  end
end

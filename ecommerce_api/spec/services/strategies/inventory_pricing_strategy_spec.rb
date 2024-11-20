require 'rails_helper'

RSpec.describe Strategies::InventoryPricingStrategy do
  let(:product) { create(:product, default_price: Money.new(1000), qty: 10) } # $10.00 default price, low inventory

  describe '#update_price' do
    it 'increases price for low inventory' do
      strategy = described_class.new(product)
      updated_price = strategy.update_price(Money.new(1000)) # $10.00 initial price

      expect(updated_price).to eq(Money.new(1010)) # $10.10 after 1% increase
    end

    it 'decreases price for high inventory' do
      product.update(qty: 200) # High inventory
      strategy = described_class.new(product)
      updated_price = strategy.update_price(Money.new(1000))

      expect(updated_price).to eq(Money.new(995)) # $9.50 after 5% decrease
    end

    it 'does not change price for moderate inventory' do
      product.update(qty: 50) # Moderate inventory
      strategy = described_class.new(product)
      updated_price = strategy.update_price(Money.new(1000))

      expect(updated_price).to eq(Money.new(1000)) # No change
    end
  end
end

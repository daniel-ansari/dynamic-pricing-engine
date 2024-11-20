require 'rails_helper'

RSpec.describe Strategies::CompetitorPricingStrategy do
  let(:product) { create(:product, default_price: Money.new(1000)) } # $10.00 default price

  before do
    create(:competitor_price, product: product, price: Money.new(900)) # Competitor price: $9.00
  end

  describe '#update_price' do
    it 'adjusts price to 5% lower if competitor price is lower' do
      strategy = described_class.new(product)
      updated_price = strategy.update_price(Money.new(1000)) # $10.00 initial price

      expect(updated_price).to eq(Money.new(855)) # $9.00 * 0.95
    end

    it 'adjusts price to 5% higher if competitor price is higher' do
      product.competitor_price.update(price: Money.new(1100)) # Competitor price: $11.00
      strategy = described_class.new(product)
      updated_price = strategy.update_price(Money.new(1000))

      expect(updated_price).to eq(Money.new(1155)) # $11.00 * 1.05
    end

    it 'does not change price if no competitor price is available' do
      product.competitor_price.destroy
      strategy = described_class.new(product)
      updated_price = strategy.update_price(Money.new(1000))

      expect(updated_price).to eq(Money.new(1000)) # No change
    end
  end
end

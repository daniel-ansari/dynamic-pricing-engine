require 'rails_helper'

RSpec.describe DynamicPricingEngine do
  let(:product) { create(:product, default_price: Money.new(1000), qty: 50) } # Default price: $10.00
  let(:dynamic_pricing_engine) { described_class.new(product) } # Default price: $10.00

  before do
    # Stubbing strategies
    allow(Strategies::DemandPricingStrategy).to receive(:new).and_return(double(update_price: Money.new(1100))) # $11.00
    allow(Strategies::InventoryPricingStrategy).to receive(:new).and_return(double(update_price: Money.new(1050))) # $10.50
    allow(Strategies::CompetitorPricingStrategy).to receive(:new).and_return(double(update_price: Money.new(950))) # $9.50
  end

  describe '#update_price' do
    it 'applies all strategies and updates the product price' do
      dynamic_pricing_engine.update_price

      updated_price = DynamicPrice.last
      expect(updated_price).not_to be_nil
      expect(updated_price.price).to eq(Money.new(950)) # Final price after strategies
    end

    it 'applies all strategies and updates the product price when it should update' do
      DynamicPrice.create(product: product, price: product.price, updated_at: 2.hour)
      dynamic_pricing_engine.update_price

      updated_price = DynamicPrice.last
      expect(updated_price).not_to be_nil
      expect(updated_price.price).to eq(Money.new(950)) # Final price after strategies
    end
  end
end

require 'rails_helper'

RSpec.describe UpdateProductPricesJob, type: :job do
  let!(:product1) { create(:product) }
  let!(:product2) { create(:product) }

  describe '#perform' do
    let(:dynamic_pricing_engine) { instance_double(DynamicPricingEngine) }

    before do
      # Mocking the DynamicPricingEngine to prevent real price updates
      allow(DynamicPricingEngine).to receive(:new).and_return(dynamic_pricing_engine)
      allow(dynamic_pricing_engine).to receive(:update_price)
    end

    it 'calls update_price for each product' do
      # Perform the job
      described_class.new.perform

      # Expecting the update_price method to be called for each product
      expect(DynamicPricingEngine).to have_received(:new).with(product1)
      expect(DynamicPricingEngine).to have_received(:new).with(product2)

      expect(dynamic_pricing_engine).to have_received(:update_price).twice
    end
  end
end

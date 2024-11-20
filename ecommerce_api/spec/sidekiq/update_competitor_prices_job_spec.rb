require 'rails_helper'

RSpec.describe UpdateCompetitorPricesJob, type: :job do
  let(:api_key) { "test_api_key" }
  let(:base_url) { "https://mock-competitor-pricing.com" }

  let!(:product1) { create(:product, name: "Product A") }
  let!(:product2) { create(:product, name: "Product B") }
  let(:competitor_response) { { status: 200, body: response_body.to_json } }

  let(:response_body) do
    [
      { name: "Product A", price: 1500 }, # $15.00
      { name: "Product B", price: 2000 }, # $20.00
      { name: "Non-existent Product", price: 3000 } # Should be ignored
    ]
  end

  before do
    # Mock environment variables
    stub_const("ENV", ENV.to_h.merge("COMPETITOR_API_KEY" => api_key, "COMPETITOR_PRICING_API" => base_url))

    stub_request(:get, "#{base_url}/prices")
      .with(query: { api_key: api_key })
      .to_return(competitor_response)
    allow(UpdateProductPricesJob).to receive(:perform_async)
  end

  describe '#perform' do
    it 'updates competitor prices for existing products' do
      expect do
        described_class.new.perform
      end.to change(CompetitorPrice, :count).by(2)

      competitor_price1 = CompetitorPrice.find_by(product: product1)
      competitor_price2 = CompetitorPrice.find_by(product: product2)

      expect(competitor_price1.price.cents).to eq(1500) # $15.00
      expect(competitor_price2.price.cents).to eq(2000) # $20.00
    end

    it 'ignores products that do not exist in the system' do
      described_class.new.perform

      non_existent_product = CompetitorPrice.exists?(name: "Non-existent Product")
      expect(non_existent_product).to be_falsy
    end

    it 'calls the UpdateProductPricesJob after updating prices' do
      described_class.new.perform

      expect(UpdateProductPricesJob).to have_received(:perform_async).once
    end

    describe 'raises an error for non-200 responses from the API' do
      context '500 Internal Server Error' do
        let(:competitor_response) { { status: 500, body: "Internal Server Error" } }

        it 'raises an error for 500 responses from the API' do
          expect {
            described_class.new.perform
          }.to raise_error(Competitor::ServerError, "Internal Server Error: Internal Server Error")

          expect(CompetitorPrice.count).to eq(0)

          expect(UpdateProductPricesJob).not_to have_received(:perform_async)
        end
      end

      context '422 Unprocessable Content' do
        let(:competitor_response) { { status: 422, body: "Unprocessable Content" } }

        it 'raises an error for 422 responses from the API' do
          expect {
            described_class.new.perform
          }.to raise_error(Competitor::ClientError, "Unprocessable Content: Unprocessable Content")

          expect(CompetitorPrice.count).to eq(0)

          expect(UpdateProductPricesJob).not_to have_received(:perform_async)
        end
      end

      context '400 Unexpected Response' do
        let(:competitor_response) { { status: 400, body: "UnexpectedResponseError" } }

        it 'raises an error for 404 responses from the API' do
          expect {
            described_class.new.perform
          }.to raise_error(Competitor::UnexpectedResponseError, "Unexpected Response: 400")

          expect(CompetitorPrice.count).to eq(0)

          expect(UpdateProductPricesJob).not_to have_received(:perform_async)
        end
      end
    end
  end
end

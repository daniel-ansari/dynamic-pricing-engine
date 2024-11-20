require 'rails_helper'

RSpec.describe CompetitorPrice, type: :model do
  describe 'validations' do
    it 'is valid with a price and product' do
      product = create(:product)  # Create a product using the factory
      competitor_price = build(:competitor_price, product: product)  # Build a dynamic price for that product

      expect(competitor_price).to be_valid  # Check if it is valid
    end

    it 'is invalid without a price' do
      product = create(:product)
      competitor_price = build(:competitor_price, price: nil, product: product)

      expect(competitor_price).to_not be_valid
      expect(competitor_price.errors[:price]).to include("can't be blank")
    end

    it 'is invalid without a product' do
      competitor_price = build(:competitor_price, product: nil)

      expect(competitor_price).to_not be_valid
      expect(competitor_price.errors[:product]).to include("can't be blank")
    end
  end

  describe '#price' do
    let(:product) { create(:product) }
    let(:competitor_price) { create(:competitor_price, product: product) }

    context 'when a dynamic price exists' do
      it 'returns the dynamic price' do
        expect(competitor_price.price).to be_a(Money)
        expect(competitor_price.price.currency.iso_code).to eq("USD")
      end
    end
  end
end

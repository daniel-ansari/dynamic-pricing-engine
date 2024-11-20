require 'rails_helper'

RSpec.describe DynamicPrice, type: :model do
  describe 'validations' do
    it 'is valid with a price and product' do
      product = create(:product)  # Create a product using the factory
      dynamic_price = build(:dynamic_price, product: product)  # Build a dynamic price for that product

      expect(dynamic_price).to be_valid  # Check if it is valid
    end

    it 'is invalid without a price' do
      product = create(:product)
      dynamic_price = build(:dynamic_price, price: nil, product: product)

      expect(dynamic_price).to_not be_valid
      expect(dynamic_price.errors[:price]).to include("can't be blank")
    end

    it 'is invalid without a product' do
      dynamic_price = build(:dynamic_price, product: nil)

      expect(dynamic_price).to_not be_valid
      expect(dynamic_price.errors[:product]).to include("can't be blank")
    end
  end

  describe '#price' do
    let(:product) { create(:product) }
    let(:dynamic_price) { create(:dynamic_price, product: product) }

    context 'when a dynamic price exists' do
      it 'returns the dynamic price' do
        expect(dynamic_price.price).to be_a(Money)
        expect(dynamic_price.price.currency.iso_code).to eq("USD")
      end
    end
  end
end

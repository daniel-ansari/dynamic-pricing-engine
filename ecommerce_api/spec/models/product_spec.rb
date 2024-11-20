require 'rails_helper'

RSpec.describe Product, type: :model do
  it { is_expected.to belong_to(:category) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:default_price) }

  # describe 'associations' do
  #   it { should belong_to(:category) }
  #   it { should have_many(:dynamic_prices).dependent(:destroy) }
  # end

  describe '#price' do
    let(:product) { create(:product) }

    context 'when dynamic prices exist' do
      it 'returns the most recent dynamic price' do
        recent_price = product.dynamic_prices.create!(price: Money.new(1500, "USD"), created_at: Time.now)
        expect(product.price).to eq(recent_price.price)
      end
    end

    context 'when no dynamic prices exist' do
      it 'returns the default price' do
        expect(product.price).to eq(product.default_price)
      end
    end
  end
end

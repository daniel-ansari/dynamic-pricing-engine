require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  describe 'validations' do
    it 'is valid with a quantity greater than 0' do
      order_item = build(:order_item, quantity: 1)
      expect(order_item).to be_valid
    end

    it 'is invalid with a quantity less than or equal to 0' do
      order_item = build(:order_item, quantity: 0)
      expect(order_item).not_to be_valid
    end
  end

  describe '#total_price' do
    let(:product) { create(:product, default_price: Money.new(1000, "USD"), qty: 10) } # $10.00
    let(:order) { create(:order) }
    let(:order_item) { build(:order_item, order: order, product: product, quantity: 5, price: product.price) }

    it 'calculates the total price correctly in cents' do
      order_item.save
      expect(order_item.order.total_price.cents).to eq(5000) # 5 * 1000 (price cents) = 5000
      expect(order_item.order.total_quantity).to eq(5)
    end
  end

  describe '#calculate_total_price' do
    let(:product) { create(:product) }
    let(:order) { create(:order, order_items: [ build(:order_item, product: product, quantity: 3) ]) }

    it 'calls order.set_total_price when saved' do
      expect(order).to receive(:set_total_price) # Expecting the set_total_price method to be called
      order_item = order.order_items.first
      order_item.save # Trigger the after_save callback
    end
  end
end

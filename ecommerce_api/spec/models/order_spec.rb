require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      order = build(:order)
      expect(order).to be_valid
    end
  end

  describe 'state transitions' do
    let(:order) { create(:order) }

    context 'when placed in the cart' do
      it 'transitions to completed when place_order is triggered with sufficient inventory' do
        allow(order).to receive(:sufficient_inventory?).and_return(true)
        order.place_order
        expect(order.status).to eq('completed')
      end

      it 'transitions to failed_due_to_low_inventory when place_order is triggered with insufficient inventory' do
        allow(order).to receive(:sufficient_inventory?).and_return(false)
        order.place_order
        expect(order.status).to eq('failed_due_to_low_inventory')
      end

      it 'transitions to canceled when cancel is triggered' do
        order.cancel
        expect(order.status).to eq('canceled')
      end
    end
  end

  describe '#set_total_price' do
    let(:order) { create(:order) }

    it 'sets the total_price and total_quantity based on order_items' do
      order.set_total_price
      expect(order.total_price).to eq(Money.new(order.order_items.sum { |item| item.total_price_cents.to_i }, "USD"))
      expect(order.total_quantity).to eq(order.order_items.sum { |item| item.quantity.to_i })
    end
  end

  describe '#sufficient_inventory?' do
    let(:product) { create(:product, qty: 10) }
    let(:order) { create(:order, order_items: [ build(:order_item, product: product, quantity: 5) ]) }

    it 'returns true if all items in the order have sufficient inventory' do
      expect(order.send(:sufficient_inventory?)).to be(true)
    end

    it 'returns false if any item in the order has insufficient inventory' do
      order.order_items.first.update(quantity: 15) # Exceed product quantity
      expect(order.send(:sufficient_inventory?)).to be(false)
    end
  end

  describe '#adjust_inventory' do
    let(:product) { create(:product, qty: 10) }
    let(:order) { create(:order, order_items: [ build(:order_item, product: product, quantity: 5) ]) }

    it 'adjusts the product inventory when the order is placed' do
      order.send(:adjust_inventory)
      expect(product.reload.qty).to eq(5)  # Product qty should be reduced by 5
    end
  end
end

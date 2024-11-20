require 'rails_helper'

RSpec.describe API::OrdersController, type: :request do
  let!(:cart) { create(:order, status: 'cart') }
  let!(:product) { create(:product) }
  let!(:order_item) { create(:order_item, order: cart, product: product, quantity: 2, price: product.price) }

  describe 'POST /api/orders' do
    context 'when placing an order successfully' do
      it 'changes the status to completed and adjusts inventory' do
        qty = product.qty
        expect {
          post api_orders_path(cart_id: cart.id.to_s)
        }.to change { cart.reload.status }.from('cart').to('completed')

        expect(response).to have_http_status(:ok)
        expect(json['order']['status']).to eq('completed')

        product.reload
        expect(product.qty).to eq(qty - order_item.quantity)
      end
    end

    context 'when inventory is insufficient' do
      before { product.update!(qty: 1) }

      it 'changes the status to failed_due_to_low_inventory' do
        expect {
          post api_orders_path(cart_id: cart.id.to_s)
        }.to change { cart.reload.status }.from('cart').to('failed_due_to_low_inventory')

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['order']['status']).to eq('failed_due_to_low_inventory')
      end
    end
  end

  describe 'DELETE /orders' do
    context 'when canceling an order successfully' do
      it 'changes the status to canceled' do
        expect {
          delete api_order_path(cart_id: cart.id.to_s)
        }.to change { cart.reload.status }.from('cart').to('canceled')

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['order']['status']).to eq('canceled')
      end
    end

    context 'when order does not exist' do
      it 'returns a 404 error' do
        delete api_order_path(cart_id: 'invalid_id')
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end

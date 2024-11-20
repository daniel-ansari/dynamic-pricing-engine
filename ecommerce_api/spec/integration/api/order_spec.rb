require 'swagger_helper'

RSpec.describe 'Orders API', type: :request do
  let!(:cart) { create(:order, status: 'cart') }
  let!(:product) { create(:product, qty: 5) }
  let!(:order_item) { create(:order_item, order: cart, product: product, quantity: 2, price: product.price) }

  path '/api/orders' do
    post 'Places an order' do
      tags 'Orders'
      consumes 'application/json'
      parameter name: :cart_id, in: :query, type: :string, description: 'Cart ID'

      response '200', 'order placed successfully' do
        let(:cart_id) { cart.id.to_s }
        run_test! do |response|
          json_response = JSON.parse(response.body)
          expect(json_response['order']['status']).to eq('completed')
        end
      end

      response '422', 'insufficient inventory' do
        before { product.update!(qty: 1) }
        let(:cart_id) { cart.id.to_s }
        run_test! do |response|
          json_response = JSON.parse(response.body)
          expect(json_response['order']['status']).to eq('failed_due_to_low_inventory')
        end
      end

      response '404', 'cart not found' do
        let(:cart_id) { 'invalid_id' }
        run_test!
      end
    end
  end

  path '/api/orders/{cart_id}' do
    delete 'Cancels an order' do
      tags 'Orders'
      consumes 'application/json'
      parameter name: :cart_id, in: :path, type: :string, description: 'Cart ID'

      response '200', 'order canceled successfully' do
        let(:cart_id) { cart.id.to_s }
        run_test! do |response|
          json_response = JSON.parse(response.body)
          expect(json_response['order']['status']).to eq('canceled')
        end
      end

      response '404', 'cart not found' do
        let(:cart_id) { 'invalid_id' }
        run_test!
      end
    end
  end
end

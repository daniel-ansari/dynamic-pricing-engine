require 'swagger_helper'

RSpec.describe 'Cart API', type: :request do
  let(:product) { create(:product, qty: 5) }
  let(:order) { create(:order, status: 'cart') }
  let(:order_item) { create(:order_item, order: order, product: product, price: product.price, quantity: 2) }

  path '/api/cart/{id}' do
    get 'Retrieves the cart' do
      tags 'Cart'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'Cart ID'

      response '200', 'cart found' do
        let(:id) { order.id.to_s }
        run_test! do |response|
          expect(response.body).to match(/cart/)
        end
      end

      response '404', 'cart not found' do
        let(:id) { 'invalid_id' }
        run_test!
      end
    end

    delete 'Deletes the cart' do
      tags 'Cart'
      parameter name: :id, in: :path, type: :string, description: 'Cart ID'

      response '204', 'cart deleted' do
        let(:id) { order.id.to_s }
        run_test!
      end
    end
  end

  path '/api/cart/{id}/remove_item?order_item_id={order_item_id}' do
    delete 'Removes an item from the cart' do
      tags 'Cart'
      parameter name: :id, in: :path, type: :string, description: 'Cart ID'
      parameter name: :order_item_id, in: :path, type: :string, description: 'Order Item ID'

      response '200', 'item removed' do
        let(:id) { order_item.order.id.to_s }
        let(:order_item_id) { order_item.id.to_s }
        run_test!
      end
    end
  end

  path '/api/cart' do
    post 'Adds a product to the cart' do
      tags 'Cart'
      consumes 'application/json'
      parameter name: :cart, in: :body, schema: {
        type: :object,
        properties: {
          product_id: { type: :string, description: 'Product ID' },
          quantity: { type: :integer, description: 'Product quantity' }
        },
        required: [ 'product_id', 'quantity' ]
      }

      response '200', 'product added to cart' do
        let(:cart) { { product_id: product.id.to_s, quantity: 1 } }
        run_test!
      end

      response '400', 'invalid attributes' do
        let(:cart) { { product_id: nil, quantity: 0 } }
        run_test!
      end
    end
  end
end

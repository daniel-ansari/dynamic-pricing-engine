require 'rails_helper'

RSpec.describe API::CartController, type: :request do
  let(:product) { create(:product) }
  let(:order) { create(:order, status: 'cart') }
  let(:order_item) { create(:order_item, order: order, product: product, quantity: 2, price: product.price) }
  let(:valid_attributes) { { cart: { product_id: product.id.to_s, quantity: 1 } } }
  let(:invalid_attributes) { { cart: { product_id: nil, quantity: 0 } } }
  let(:invalid_attributes2) { { product_id: product.id.to_s, quantity: 1 } }

  describe 'POST /api/carts' do
    it 'adds a product to the cart' do
      post api_cart_index_path, params: valid_attributes.merge(id: order.id.to_s)
      expect(response).to have_http_status(:ok)
      expect(json['cart']['order_items'].size).to eq(1)
    end

    it 'returns error if product_id is invalid' do
      post api_cart_index_path, params: invalid_attributes
      expect(response).to have_http_status(:bad_request)
      expect(json['errors']).to include('The record must be exist.')
    end

    it 'returns error if cart paramter is missing' do
      post api_cart_index_path, params: invalid_attributes2
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json['errors']).to include('param is missing or the value is empty: cart')
    end
  end

  describe 'GET /api/carts/:id' do
    it 'retrieves the cart' do
      get api_cart_path(order.id.to_s)
      expect(response).to have_http_status(:ok)
      expect(json['cart']['id']).to eq(order.id.to_s)
    end
  end

  describe 'DELETE /api/carts/:id' do
    it 'destroys the cart' do
      delete api_cart_path(order.id.to_s)
      expect(response).to have_http_status(:no_content)
      expect(Order.exists?(order.id)).to be_falsey
    end
  end

  describe 'DELETE /api/carts/:id/remove_item' do
    it 'removes an item from the cart' do
      delete remove_item_api_cart_path(order.id.to_s, order_item_id: order_item.id.to_s)
      expect(response).to have_http_status(:ok)
      expect(json['cart']['order_items']).to be_empty
    end
  end
end

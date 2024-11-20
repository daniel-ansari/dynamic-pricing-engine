require 'rails_helper'

RSpec.describe API::ProductsController, type: :request do
  let!(:product) { create(:product) }

  describe 'GET /api/products' do
    it 'retrieves all products' do
      get api_products_path
      expect(response).to have_http_status(:ok)
      expect(json['products'].size).to eq(1)
      expect(json['products'][0]['id']).to eq(product.id.to_s)
    end
  end

  describe 'GET /api/products/:id' do
    it 'retrieves the product' do
      get api_product_path(product.id)
      expect(response).to have_http_status(:ok)
      expect(json['product']['id']).to eq(product.id.to_s)
    end
  end
end

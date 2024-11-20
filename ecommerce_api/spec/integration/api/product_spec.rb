require 'swagger_helper'

RSpec.describe 'Products API', type: :request do
  let!(:product) { create(:product) }

  path '/api/products' do
    get 'Retrieves all products' do
      tags 'Products'
      produces 'application/json'

      response '200', 'Products found' do
        schema type: :object do
          property :products, type: :array do
            items do
              property :id, type: :string, description: 'Product ID'
              property :name, type: :string, description: 'Product name'
              property :category, type: :string, description: 'Product category'
              property :price, type: :number, format: :float, description: 'Product price'
            end
          end
        end

        run_test! do
          expect(response).to have_http_status(200)
          expect(json['products']).to be_an(Array)
        end
      end
    end
  end

  path '/api/products/{id}' do
    get 'Retrieves a product by ID' do
      tags 'Products'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'Product ID'

      response '200', 'Product found' do
        let(:id) { product.id }

        schema type: :object do
          property :id, type: :string, description: 'Product ID'
          property :name, type: :string, description: 'Product name'
          property :category, type: :string, description: 'Product category'
          property :price, type: :number, format: :float, description: 'Product price'
        end

        run_test! do
          expect(response).to have_http_status(200)
          expect(json.dig("product", "id")).to eq(product.id.to_s)
        end
      end

      response '404', 'Product not found' do
        let(:id) { 'invalid_id' }

        run_test! do
          expect(response).to have_http_status(404)
        end
      end
    end
  end
end

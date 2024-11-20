require 'rails_helper'

RSpec.describe ImportInventory do
  let(:csv_file_path) { Rails.root.join('spec', 'fixtures', 'files', 'inventory.csv') }
  let(:csv_content) do
    <<~CSV
      name,category,default_price,qty
      Product 1,Category A,1000,50
      Product 2,Category B,2000,30
      Product 1,Category A,1500,20
    CSV
  end

  before do
    # Create a temporary CSV file for testing
    File.write(csv_file_path, csv_content)
  end

  after do
    # Clean up the temporary file
    File.delete(csv_file_path) if File.exist?(csv_file_path)
  end

  describe '.import' do
    it 'imports inventory from the CSV file' do
      result = described_class.import(csv_file_path)

      expect(result[:total]).to eq(3)
      expect(result[:succeeded]).to eq(3)

      category_a = Category.find_by(name: 'Category A')
      category_b = Category.find_by(name: 'Category B')

      expect(category_a).not_to be_nil
      expect(category_b).not_to be_nil

      product_1 = Product.find_by(name: 'Product 1', category: category_a)
      product_2 = Product.find_by(name: 'Product 2', category: category_b)

      expect(product_1.default_price.cents).to eq(1500) # Updated price
      expect(product_1.qty).to eq(70)                  # Updated quantity
      expect(product_2.default_price.cents).to eq(2000)
      expect(product_2.qty).to eq(30)
    end

    it 'does not create duplicate categories' do
      described_class.import(csv_file_path)

      expect(Category.where(name: 'Category A').count).to eq(1)
      expect(Category.where(name: 'Category B').count).to eq(1)
    end

    it 'handles invalid rows gracefully' do
      # Create a CSV file with an invalid row
      invalid_csv_content = <<~CSV
        name,category,default_price,qty
        ,Category A,1000,50
        Product 2,Category B,,30
      CSV
      File.write(csv_file_path, invalid_csv_content)

      result = described_class.import(csv_file_path)

      expect(result[:total]).to eq(2)
      expect(result[:succeeded]).to eq(0) # No rows should succeed due to invalid data
    end
  end
end

class ImportInventory
  require "csv"

  def initialize(file)
    @file = file
  end

  def import_inventory_from_csv
    status = { total: 0, succeeded: 0 }

    CSV.foreach(@file, headers: true, header_converters: :symbol) do |row|
      status[:total] += 1
      next if row[:default_price].nil? || row[:qty].nil?

      category = Category.find_or_create_by(name: row[:category])
      next unless category.valid?

      product = Product.find_or_initialize_by(category: category, name: row[:name])

      product.default_price = Money.new(row[:default_price].to_i)
      product.qty += row[:qty].to_i

      status[:succeeded] += 1 if product.save
    end

    status
  end

  def self.import(file)
    inventory = ImportInventory.new(file)

    inventory.import_inventory_from_csv
  end
end

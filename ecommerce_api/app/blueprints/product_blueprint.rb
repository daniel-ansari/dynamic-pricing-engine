# frozen_string_literal: true

class ProductBlueprint < Blueprinter::Base
  identifier :id
  fields :name, :price
  field :category do |product|
    product.category_name
  end
end

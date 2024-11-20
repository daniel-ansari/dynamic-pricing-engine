# frozen_string_literal: true

class OrderItemBlueprint < Blueprinter::Base
  identifier :id
  fields :quantity, :price, :created_at
  association :product, blueprint: ProductBlueprint
end

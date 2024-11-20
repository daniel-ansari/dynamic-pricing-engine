# frozen_string_literal: true

class OrderBlueprint < Blueprinter::Base
  identifier :id
  fields :status, :total_quantity, :total_price, :created_at
  association :order_items, blueprint: OrderItemBlueprint
end

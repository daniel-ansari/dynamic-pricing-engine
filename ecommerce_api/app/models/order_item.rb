class OrderItem
  include Mongoid::Document
  include Mongoid::Timestamps

  field :quantity, type: Integer, default: 0
  field :price, type: Money

  belongs_to :product
  embedded_in :order

  index({ product_id: 1, created_at: -1, "order.status": 1 })

  validates :quantity, numericality: { greater_than: 0 }

  after_save :calculate_total_price

  def calculate_total_price
    order.set_total_price
  end

  def total_price
    price * quantity
  end
end

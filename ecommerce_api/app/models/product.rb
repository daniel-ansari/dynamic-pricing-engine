class Product
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :qty, type: Integer, default: 0
  field :default_price, type: Money

  belongs_to :category
  has_one :competitor_price
  has_many :dynamic_prices, dependent: :destroy

  validates :name, :default_price, :qty, :category_id, presence: true
  validates :qty, numericality: { greater_than_or_equal_to: 0 }

  delegate :name, to: :category, prefix: true, allow_nil: true

  def price
    dynamic_price = dynamic_prices.order(created_at: :desc).first
    if dynamic_price.present?
      dynamic_price.price
    else
      default_price
    end
  end

  def demand_high?
    total_ordered_qty_in_last_30_days > 100
  end

  private

  def total_ordered_qty_in_last_30_days
    result = Order.collection.aggregate([
      {
        "$match": {
          "created_at": { "$gte": 30.days.ago },
          "status": "completed"
        }
      },
      {
        "$unwind": "$order_items"  # Unwind the embedded order_items array
      },
      {
        "$match": {
          "order_items.product_id": self.id  # Filter by product_id within order_items
        }
      },
      {
        "$group": {
          "_id": "$order_items.product_id",  # Group by product_id
          "total_quantity": { "$sum": "$order_items.quantity" }  # Sum the quantity of order_items
        }
      }
    ])

    # Return the total quantity for this product
    result.first ? result.first["total_quantity"] : 0
  end
end

class Order
  include Mongoid::Document
  include Mongoid::Timestamps
  include AASM

  field :status, type: String, default: "cart"
  field :total_price, type: Money
  field :total_quantity, type: Integer, default: 0

  # belongs_to :owner, polymorphic: true
  embeds_many :order_items

  # validates :owner, presence: true

  aasm column: :status do
    state :cart, initial: true
    state :completed
    state :canceled
    state :failed_due_to_low_inventory

    event :place_order do
      transitions from: :cart, to: :completed, guard: :sufficient_inventory?, after: :adjust_inventory

      transitions from: :cart, to: :failed_due_to_low_inventory, guard: :insufficient_inventory?
    end

    event :cancel do
      transitions from: [ :cart ], to: :canceled
    end
  end

  def set_total_price
    self.total_price = order_items.sum { |item| item.total_price }
    self.total_quantity = order_items.sum { |item| item.quantity.to_i }

    self.save
  end

  private

  def sufficient_inventory?
    order_items.all? do |item|
      product = Product.find(item.product_id)
      product.qty >= item.quantity
    end
  end

  def insufficient_inventory?
    !sufficient_inventory?
  end

  def adjust_inventory
    order_items.each do |item|
      product = Product.find(item.product_id)
      product.qty -= item.quantity
      product.save!
    end
  end
end

class CompetitorPrice
  include Mongoid::Document
  include Mongoid::Timestamps

  field :price, type: Money
  belongs_to :product

  validates :price, :product_id, presence: true
end

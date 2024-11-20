class AnonymousUser
  include Mongoid::Document
  include Mongoid::Timestamps

  field :request_id, type: String
  field :token, type: String

  validates :request_id, presence: true

  # has_many :orders, as: :owner
end

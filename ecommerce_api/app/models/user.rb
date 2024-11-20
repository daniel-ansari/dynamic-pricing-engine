class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :email, type: String
  field :password_digest, type: String
  field :admin, type: Mongoid::Boolean
  field :verified, type: Mongoid::Boolean

  # has_many :orders, as: :owner
end

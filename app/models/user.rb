class User < ApplicationRecord
  has_secure_password

  has_many :events
  has_many :reservations

  validates :email, presence: true, uniqueness: true

  def get_token
    encode_token(user_id: id)
  end

  private

  def encode_token(payload)
    JWT.encode(payload, secret_key, "HS256")
  end

  def secret_key
    Rails.application.credentials.secret_jwt_key
  end
end
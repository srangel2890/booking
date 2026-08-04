class User < ApplicationRecord
  has_many :events
  has_many :reservations

  has_secure_password
end

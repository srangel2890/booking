class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :event

  has_many :tickets

  validates :status, presence: true
  validates :confirmation_code, presence: true, uniqueness: true
end
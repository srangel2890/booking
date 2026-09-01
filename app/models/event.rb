class Event < ApplicationRecord
  belongs_to :user
  belongs_to :venue

  has_many :ticket_types
  has_many :reservations

  validates :name, presence: true
  validates :starts_at, presence: true
end
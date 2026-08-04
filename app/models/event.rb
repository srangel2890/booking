class Event < ApplicationRecord
  belongs_to :user
  belongs_to :venue
  has_many :ticket_types
  has_many :reservations
end

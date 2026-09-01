class Venue < ApplicationRecord
  has_many :events

  validates :name, presence: true
end
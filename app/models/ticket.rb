class Ticket < ApplicationRecord
  belongs_to :reservation
  has_one :ticket_type
end

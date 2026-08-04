# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


user = User.create!(
  email: "organizer@example.com",
  password: "password",
  name: "John Doe"
)

venue = Venue.create!(
  name: "Teatro Metropolitano"
)

event = Event.create!(
  name: "Concierto de prueba",
  venue: venue,
  user: user,
  starts_at: 1.month.from_now
)

event.ticket_types.create!([
  { name: "General", price: 500 },
  { name: "VIP", price: 1_200 }
])

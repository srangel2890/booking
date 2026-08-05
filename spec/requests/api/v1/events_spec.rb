require "rails_helper"

RSpec.describe "Api::V1::Events", type: :request do
  let!(:user) do
    User.create!(
      email: "organizer@example.com",
      name: 'Tom Hanks',
      password: "password123",
      password_confirmation: "password123"
    )
  end

  let!(:venue) do
    Venue.create!(
      name: "Teatro Metropolitano"
    )
  end

  let!(:event) do
    Event.create!(
      name: "Concierto de prueba",
      starts_at: 1.month.from_now,
      user: user,
      venue: venue
    )
  end

  let!(:ticket_type) do
    TicketType.create!(
      name: "General",
      price: 500,
      event: event
    )
  end

  describe "GET /api/v1/events" do
    it "returns all events" do
      get "/api/v1/events"

      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)

      expect(body.length).to eq(1)
      expect(body.first["id"]).to eq(event.id)
      expect(body.first["name"]).to eq("Concierto de prueba")
      expect(body.first["venue"]["id"]).to eq(venue.id)
      expect(body.first["ticket_types"].first["id"]).to eq(ticket_type.id)
    end
  end

  describe "GET /api/v1/events/:id" do
    it "returns the requested event" do
      get "/api/v1/events/#{event.id}"

      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)

      expect(body["id"]).to eq(event.id)
      expect(body["name"]).to eq("Concierto de prueba")
      expect(body["venue"]["name"]).to eq("Teatro Metropolitano")
      expect(body["ticket_types"].first["name"]).to eq("General")
    end
  end
end
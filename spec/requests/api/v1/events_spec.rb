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

  let!(:other_user) do
    User.create!(
      email: "other@example.com",
      name: "Other User",
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

  let(:headers) do
    {
      "Authorization" => "Bearer #{user.get_token}"
    }
  end

  describe "GET /api/v1/events" do
    it "returns all events" do
      get "/api/v1/events", headers: headers

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
      get "/api/v1/events/#{event.id}", headers: headers

      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)

      expect(body["id"]).to eq(event.id)
      expect(body["name"]).to eq("Concierto de prueba")
      expect(body["venue"]["name"]).to eq("Teatro Metropolitano")
      expect(body["ticket_types"].first["name"]).to eq("General")
    end
  end

  describe "POST /api/v1/events" do
    it "creates an event for the authenticated user" do
      expect {
        post "/api/v1/events",
            params: {
              event: {
                name: "Nuevo concierto",
                starts_at: 2.months.from_now,
                venue_id: venue.id
              }
            },
            headers: headers
      }.to change(Event, :count).by(1)

      expect(response).to have_http_status(:created)

      created_event = Event.order(:created_at).last

      expect(created_event.name).to eq("Nuevo concierto")
      expect(created_event.user_id).to eq(user.id)
      expect(created_event.venue_id).to eq(venue.id)
    end

    it "requires authentication" do
      expect {
        post "/api/v1/events",
            params: {
              event: {
                name: "Nuevo concierto",
                starts_at: 2.months.from_now,
                venue_id: venue.id
              }
            }
      }.not_to change(Event, :count)

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "PATCH /api/v1/events/:id" do
    it "allows the owner to update the event" do
      patch "/api/v1/events/#{event.id}",
            params: {
              event: {
                name: "Concierto actualizado"
              }
            },
            headers: headers

      expect(response).to have_http_status(:ok)
      expect(event.reload.name).to eq("Concierto actualizado")
    end

    it "does not allow another user to update the event" do
      other_headers = {
        "Authorization" => "Bearer #{other_user.get_token}"
      }

      patch "/api/v1/events/#{event.id}",
            params: {
              event: {
                name: "Evento robado"
              }
            },
            headers: other_headers

      expect(response).to have_http_status(:not_found)
      expect(event.reload.name).to eq("Concierto de prueba")
    end
  end

  describe "DELETE /api/v1/events/:id" do
    it "allows the owner to delete the event" do
      expect {
        delete "/api/v1/events/#{event.id}", headers: headers
      }.to change(Event, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it "does not allow another user to delete the event" do
      other_headers = {
        "Authorization" => "Bearer #{other_user.get_token}"
      }

      expect {
        delete "/api/v1/events/#{event.id}", headers: other_headers
      }.not_to change(Event, :count)

      expect(response).to have_http_status(:not_found)
    end
  end
end
require "rails_helper"

RSpec.describe "Api::V1::Reservations", type: :request do
  let!(:user) do
    User.create!(
      email: "organizer@example.com",
      name: "Tom Hanks",
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
      quantity: 5,
      event: event
    )
  end

  let(:headers) do
    {
      "Authorization" => "Bearer #{user.get_token}"
    }
  end

  describe "POST /api/v1/reservations" do
    it "creates a reservation" do
      expect {
        post "/api/v1/reservations",
             params: {
               reservation: {
                 event_id: event.id,
                 tickets: [
                   {
                     ticket_type_id: ticket_type.id,
                     attendee_name: "Sara",
                     attendee_email: "sara@example.com"
                   }
                 ]
               }
             },
             headers: headers
      }.to change(Reservation, :count).by(1)
       .and change(Ticket, :count).by(1)

      expect(response).to have_http_status(:created)

      body = JSON.parse(response.body)

      expect(body["total"].to_f).to eq(500.0)
      expect(body["tickets"].length).to eq(1)
      expect(body["tickets"].first["ticket_type"]["id"]).to eq(ticket_type.id)
      expect(ticket_type.reload.quantity).to eq(4)
    end

    it "rejects a reservation without tickets" do
      post "/api/v1/reservations",
           params: {
             reservation: {
               event_id: event.id,
               tickets: []
             }
           },
           headers: headers

      expect(response).to have_http_status(:unprocessable_content)

      body = JSON.parse(response.body)

      expect(body["error"]).to eq(
        "Reservation must contain at least one ticket"
      )
    end

    it "rejects a reservation when there are not enough tickets" do
      post "/api/v1/reservations",
           params: {
             reservation: {
               event_id: event.id,
               tickets: Array.new(6) do
                 {
                   ticket_type_id: ticket_type.id,
                   attendee_name: "Sara",
                   attendee_email: "sara@example.com"
                 }
               end
             }
           },
           headers: headers

      expect(response).to have_http_status(:unprocessable_content)

      body = JSON.parse(response.body)

      expect(body["error"]).to eq(
        "Not enough tickets available for General"
      )

      expect(Reservation.count).to eq(0)
      expect(Ticket.count).to eq(0)
      expect(ticket_type.reload.quantity).to eq(5)
    end

    it "requires authentication" do
      post "/api/v1/reservations",
           params: {
             reservation: {
               event_id: event.id,
               tickets: [
                 {
                   ticket_type_id: ticket_type.id,
                   attendee_name: "Sara",
                   attendee_email: "sara@example.com"
                 }
               ]
             }
           }

      expect(response).to have_http_status(:unauthorized)

      body = JSON.parse(response.body)

      expect(body["error"]).to eq("Unauthorized")
    end
  end
end
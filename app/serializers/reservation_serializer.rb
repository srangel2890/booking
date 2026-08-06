
class ReservationSerializer
  def initialize(reservation)
    @reservation = reservation
  end

  def as_json
    {
      id: @reservation.id,
      total: 
      venue: VenueSerializer.new(@event.venue).as_json,
      tickets: @reservation.tickets.map do |ticket|
        TicketSerializer.new(ticket).as_json
      end
    }
  end
end
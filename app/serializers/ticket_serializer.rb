class TicketSerializer
  def initialize(ticket)
    @ticket = ticket
  end

  def as_json
    {
      id: @ticket.id,
      code: @ticket.code,
      attendee_name: @ticket.attendee_name,
      attendee_email: @ticket.attendee_email,
      ticket_type: {
        id: @ticket.ticket_type.id,
        name: @ticket.ticket_type.name,
        price: @ticket.ticket_type.price
      }
    }
  end
end
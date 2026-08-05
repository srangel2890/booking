class TicketTypeSerializer
  def initialize(ticket_type)
    @ticket_type = ticket_type
  end

  def as_json
    {
      id: @ticket_type.id,
      name: @ticket_type.name,
      price: @ticket_type.price
    }
  end
end
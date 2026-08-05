
class EventSerializer
  def initialize(event)
    @event = event
  end

  def as_json
    {
      id: @event.id,
      name: @event.name,
      description: @event.description,
      starts_at: @event.starts_at,
      ends_at: @event.ends_at,
      sales_end_date: @event.sales_end_date,
      capacity: @event.capacity,
      status: @event.status,
      venue: VenueSerializer.new(@event.venue).as_json,
      ticket_types: @event.ticket_types.map do |ticket_type|
        TicketTypeSerializer.new(ticket_type).as_json
      end
    }
  end
end
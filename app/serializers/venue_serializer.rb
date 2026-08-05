class VenueSerializer
  def initialize(venue)
    @venue = venue
  end

  def as_json
    {
      id: @venue.id,
      name: @venue.name
    }
  end
end
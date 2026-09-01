# app/controllers/api/v1/reservations_controller.rb
module Api
  module V1
    class ReservationsController < ApplicationController
      before_action :authenticate_user!

      def show
        reservation = Reservation.find(params[:id])
        render json: ReservationSerializer.new(reservation).as_json
      end

      def create
        event = Event.find(reservation_params[:event_id])

        ticket_types = reservation_params[:tickets].map do |ticket|
          TicketType.find(ticket[:ticket_type_id])
        end

        unless ticket_types.all? { |ticket_type| ticket_type.event_id == event.id }
          return render json: { error: "Invalid ticket type for this event" },
                        status: :unprocessable_entity
        end

        total = ticket_types.sum(&:price)

        reservation = Reservation.new(
          user: current_user,
          event: event,
          status: "confirmed",
          total: total,
          confirmation_code: SecureRandom.hex(6)
        )

        ActiveRecord::Base.transaction do
          reservation.save!

          reservation_params[:tickets].each do |ticket_params|
            reservation.tickets.create!(
              ticket_type_id: ticket_params[:ticket_type_id],
              attendee_name: ticket_params[:attendee_name],
              attendee_email: ticket_params[:attendee_email],
              code: SecureRandom.hex(8)
            )
          end
        end

        render json: ReservationSerializer.new(reservation).as_json,
              status: :created

      rescue ActiveRecord::RecordInvalid => e
        render json: { error: e.record.errors.full_messages },
              status: :unprocessable_entity
      end

      private

      def reservation_params
        params.require(:reservation).permit(
          :event_id,
          tickets: [
            :ticket_type_id,
            :attendee_name,
            :attendee_email
          ]
        )
      end
    end
  end
end
# app/controllers/api/v1/events_controller.rb
module Api
  module V1
    class ReservationsController < ApplicationController
      before_action :authenticate_user!
      
      def show
        event = Reservation.includes(:venue, :ticket_types, :tickets).find(params[:id])
        render json: ReservationSerializer.new(event).as_json
      end

      def create
        
      end

      private

      def reservation_params
        params.require(:event).permit(
          :name,
          :description,
          :starts_at,
          :ends_at,
          :sales_end_date,
          :capacity,
          :user_id,
          :venue_id,
        )
      end
    end
  end
end
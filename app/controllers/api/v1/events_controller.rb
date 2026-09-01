# app/controllers/api/v1/events_controller.rb
module Api
  module V1
    class EventsController < ApplicationController
      before_action :authenticate_user!
      
      def index
        events = Event.includes(:venue, :ticket_types)
        render json: events.map { |event| EventSerializer.new(event).as_json }
      end

      def show
        event = Event.includes(:venue, :ticket_types).find(params[:id])
        render json: EventSerializer.new(event).as_json
      end

      def create
        event = current_user.events.new(event_params)

        if event.save
          render json: EventSerializer.new(event).as_json, status: :created
        else
          render json: { errors: event.errors.full_messages },
                status: :unprocessable_content
        end
      end

      def update
       event = current_user.events.find(params[:id])

        if event.update(event_params)
          render json: event
        else
          render json: { errors: event.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        event = current_user.events.find(params[:id])
        event.destroy!
        head :no_content
      end

      private

      def event_params
        params.require(:event).permit(
          :name,
          :description,
          :starts_at,
          :ends_at,
          :sales_end_date,
          :capacity,
          :venue_id,
        )
      end
    end
  end
end
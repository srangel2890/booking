# app/controllers/api/v1/events_controller.rb
module Api
  module V1
    class EventsController < ApplicationController
      def index
        events = Event.includes(:venue, :ticket_types)
        render json: events.as_json(include: [:venue, :ticket_types])
      end

      def show
        event = Event.includes(:venue, :ticket_types).find(params[:id])
        render json: event.as_json(include: [:venue, :ticket_types])
      end

      def create
        event = Event.new(event_params)

        if event.save
          render json: event, status: :created
        else
          render json: { errors: event.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        event = Event.find(params[:id])

        if event.update(event_params)
          render json: event
        else
          render json: { errors: event.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        event = Event.find(params[:id])
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
          :user_id,
          :venue_id,
        )
      end
    end
  end
end
class EventOrganizersController < ApplicationController
  api :POST, "events/:event_id/organizers", "Add a new organizer to an event"
    description "Adds a given user to a given event as an organizer. Must be a current organizer of the event"
    error code: :unprocessable_entity, desc: " - Bad parameters for User"
    error code: :unauthorized, desc: " - Bad Token"
    param :user_id, Integer, desc: "User ID to add as an organizer", required: true
    header "Authorization", "Token token=[access_token]", required: true
  def create
    @event_organizer = EventOrganizer.new( event_id: params[:event_id], organizer_id: params[:user_id] )
    authorize @event_organizer

    if @event_organizer.save
      render json: @event_organizer, status: :created
    else
      render json: @event_organizer.errors, status: :unprocessable_entity
    end
  end

  api :GET, "events/:event_id/organizers", "Get a list of organizers for an event"
    description "Get a list of all organizers for any organized event"
    error code: :unauthorized, desc: " - Bad Token"
    header "Authorization", "Token token=[access_token]", required: true
  def index
    @event_organizers = EventOrganizer.where( event_id: params[:event_id] )
    authorize @event_organizers

    render json: @event_organizers, status: :ok
  end

  api :GET, "users/:user_id/organized_events", "Get a list of events organized by a user"
    description "Get a list of all events a user is organizing"
    error code: :unauthorized, desc: " - Bad Token"
    header "Authorization", "Token token=[access_token]", required: true
  def index_by_organizer
    @event_organizers = EventOrganizer.where( organizer_id: params[:user_id] )
    authorize @event_organizers

    render json: @event_organizers, status: :ok
  end

  api :DELETE, "events/:event_id/organizers/:id", "Remove an organizer from an event"
    description "Remove an organizer from an event. Must be an organizer for the event."
  def destroy
    @event_organizer = EventOrganizer.find_by( organizer_id: params[:id], event_id: params[:event_id] )
    authorize @event_organizer
    @event_organizer.destroy

    head :ok
  end
end

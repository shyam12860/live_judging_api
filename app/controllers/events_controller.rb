class EventsController < ApplicationController
  api :POST, "/events", "Create a new event"
    description "Create a new event for the application."
    error code: :unprocessable_entity, desc: " - Bad parameters for Event"
    error code: :unauthorized, desc: " - Bad Token"
    param :name,       String, desc: "Event name",       required: true
    param :location,   String, desc: "Event location",   required: true
    param :start_time, String, desc: "Event start time", required: true
    param :end_time,   String, desc: "Event end time",   required: true
    param :map_base64, String, desc: "Base 64 encoded image string", required: false
    header "Authorization", "Token token=[access_token]", required: true
  def create
    params[:map] = parse_image_data( params[:map_base64] ) if params[:map_base64]

    @event = Event.new( my_params )
    authorize @event

    if @event.save
      @event.organizers << current_user
      render json: @event, status: :created
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  api :PUT, "/events/:id", "Update a specific event"
    description "Update a specific event by its id"
    error code: :unprocessable_entity, desc: " - Bad parameters for Event"
    error code: :unauthorized, desc: " - Bad Token"
    param :name,       String, desc: "Event name",       required: true
    param :location,   String, desc: "Event location",   required: true
    param :start_time, String, desc: "Event start time", required: true
    param :end_time,   String, desc: "Event end time",   required: true
    param :map_base64, String, desc: "Base 64 encoded image string", required: false
    header "Authorization", "Token token=[access_token]", required: true
  def update
    @event = Event.find( params[:id] )
    authorize @event

    params[:map] = parse_image_data( params[:map_base64] ) if params[:map_base64]

    if @event.update_attributes( my_params )
      render json: @event, status: :ok
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  api :GET, "/events", "Get a list of events"
    description "Get a list of all events for the user"
    error code: :unauthorized, desc: " - Bad Token"
    header "Authorization", "Token token=[access_token]", required: true
  def index
    @events = current_user.organized_events

    if @events.any?
      authorize @events
    else
      skip_authorization
    end

    render json: @events, status: :ok
  end

  api :GET, "/events/:id", "Get a specific event"
    description "Get a specific event by its id"
    error code: :not_found, desc: " - Event not found in system"
    error code: :unauthorized, desc: " - Bad Token"
    header "Authorization", "Token token=[access_token]", required: true
  def show
    @event = Event.find( params[:id] )
    authorize @event

    render json: @event, status: :ok
  end

  private
  def my_params
    params.permit( :name, :location, :start_time, :end_time, :map )
  end
end

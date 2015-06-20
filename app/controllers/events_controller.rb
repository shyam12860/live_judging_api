class EventsController < ApplicationController
  api :POST, "/events", "Create a new event"
    description "Create a new event for the application."
    error code: :unprocessable_entity, desc: " - Bad parameters for Event"
    error code: :unauthorized, desc: " - Bad Token"
    param :name,       String, desc: "Event name",       required: true
    param :location,   String, desc: "Event location",   required: true
    param :start_time, String, desc: "Event start time", required: true
    param :end_time,   String, desc: "Event end time",   required: true
    header "Authorization", "Token token=[access_token]", required: true
  def create
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
    header "Authorization", "Token token=[access_token]", required: true
  def update
    @event = Event.find( params[:id] )
    authorize @event

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
    @organized_events = current_user.organized_events
    @events = @organized_events
    authorize @events
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

  def judges
    @event = Event.find( params[:id] )
    authorize @event 

    render json: @event.judges, status: :ok
  end

  def organizers
    @event = Event.find( params[:id] )
    authorize @event 

    render json: @event.organizers, status: :ok
  end

  private
  def my_params
    params.permit( :name, :location, :start_time, :end_time )
  end
end

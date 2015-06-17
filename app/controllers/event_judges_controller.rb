class EventJudgesController < ApplicationController
  api :POST, "/judges", "Add a new judge to an event"
    description "Adds a given user to a given event as a judge. Must be the organizer of the event"
    error code: :unprocessable_entity, desc: " - Bad parameters for User"
    error code: :unauthorized, desc: " - Bad Token"
    param :judge_id, Integer, desc: "User ID to add as a judge", required: true
    param :event_id, Integer, desc: "Event ID to add the judge to", required: true
    header "Authorization", "Token token=[access_token]", required: true
  def create
    @event_judge = EventJudge.new( my_params )
    authorize @event_judge

    if @event_judge.save
      render json: @event_judge, status: :ok
    else
      render json: @event_judge.errors, status: :unprocessable_entity
    end
  end

  api :GET, "/judges", "Get a list of judges"
    description "Get a list of all judges for the any organized events"
    error code: :unauthorized, desc: " - Bad Token"
    param :event_id, Integer, desc: "Only get judges from a specific event", required: false
    header "Authorization", "Token token=[access_token]", required: true
  def index
    @event_judges = policy_scope( EventJudge )
    authorize @event_judges

    if( event = params[:event_id] )
      @event_judges = @event_judges.where( event: event )
    end

    render json: @event_judges, status: :ok
  end

  api :DELETE, "/judges/:id", "remove a judge from an event"
    description "Remove a judge from an event"
  def destroy
    @event_judge = EventJudge.find_by( judge_id: params[:id], event_id: params[:event_id] )
    @event_judge.destroy
  end

  private
    def my_params
      params.permit( :event_id, :judge_id )
    end
end

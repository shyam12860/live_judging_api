class EventJudgesController < ApplicationController
  api :POST, "events/:event_id/judges", "Add a new judge to an event"
    description "Adds a given user to a given event as a judge. Must be an organizer of the event"
    error code: :unprocessable_entity, desc: " - Bad parameters for User"
    error code: :unauthorized, desc: " - Bad Token"
    param :user_id, Integer, desc: "User ID to add as a judge", required: true
    header "Authorization", "Token token=[access_token]", required: true
  def create
    @event_judge = EventJudge.new( event_id: params[:event_id], judge_id: params[:user_id] )
    authorize @event_judge

    if @event_judge.save
      render json: @event_judge, status: :created
    else
      render json: @event_judge.errors, status: :unprocessable_entity
    end
  end

  api :GET, "events/:event_id/judges", "Get a list of judges"
    description "Get a list of all judges for any organized event"
    error code: :unauthorized, desc: " - Bad Token"
    header "Authorization", "Token token=[access_token]", required: true
  def index
    @event_judges = EventJudge.where( event_id: params[:event_id] )
    authorize @event_judges

    render json: @event_judges, status: :ok
  end

  api :GET, "users/:user_id/judged_events", "Get a list of events being judged by a user"
    description "Get a list of all events a user can judge"
    error code: :unauthorized, desc: " - Bad Token"
    header "Authorization", "Token token=[access_token]", required: true
  def index_by_judge
    @event_judges = EventJudge.where( judge_id: params[:user_id] )
    authorize @event_judges

    render json: @event_judges, status: :ok
  end

  api :DELETE, "judges/:id", "Remove a judge from an event"
    description "Remove a judge from an event. Must be an organizer for the event."
    error code: :unauthorized, desc: " - Bad Token"
    header "Authorization", "Token token=[access_token]", required: true
  def destroy
    @event_judge = EventJudge.find( params[:id] )
    authorize @event_judge
    @event_judge.destroy

    head :ok
  end
end

class EventTeamsController < ApplicationController
  api :GET, "/event/:event_id/teams", "Get a list of event teams"
    description "Get a list of all teams for an event."
    error code: :unauthorized, desc: " - Bad Token"
    header "Authorization", "Token token=[access_token]", required: true
  def index
    @teams = EventTeam.where( event_id: params[:event_id] )
    authorize @teams

    render json: @teams, status: :ok
  end

  api :POST, "/events/:event_id/teams", "Create a new event team. Must be an organizer of the event"
    description "Create a new team for an event."
    error code: :unprocessable_entity, desc: " - Bad parameters for User"
    error code: :unauthorized, desc: " - Bad Token"
    param :name, String, desc: "Team name", required: true
    header "Authorization", "Token token=[access_token]", required: true
  def create
    @team = EventTeam.new( create_params )
    authorize @team

    if @team.save
      render json: @team, status: :created
    else
      render json: @team.errors, status: :unprocessable_entity
    end
  end

  api :PUT, "/teams/:id", "Update an event team. Must be an organizer of the event"
    description "Update an event team."
    error code: :unprocessable_entity, desc: " - Bad parameters for User"
    error code: :unauthorized, desc: " - Bad Token"
    param :name, String, desc: "Team name", required: true
    header "Authorization", "Token token=[access_token]", required: true
  def update
    @team = EventTeam.find( params[:id] )
    authorize @team

    if @team.update_attributes( update_params )
      render json: @team, status: :ok
    else
      render json: @team.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, "/teams/:id", "Delete an event team. Must be an organizer of the event."
    description "Delete an event team."
    error code: :not_found, desc: " - Requested event team did not exist"
    error code: :unauthorized, desc: " - Bad Token"
    header "Authorization", "Token token=[access_token]", required: true
  def destroy
    @team = EventTeam.find( params[:id] )
    authorize @team
    @team.destroy

    head :ok
  end

  private
    def create_params
      params.permit( :event_id, :name )
    end
    
    def update_params
      params.permit( :name )
    end
end

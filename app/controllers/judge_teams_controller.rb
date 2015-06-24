class JudgeTeamsController < ApplicationController
  api :GET, "/judges/:judge_id/teams", "Get a list of judge teams"
    description "Get a list of all judge teams."
    error code: :unauthorized, desc: " - Bad Token"
    header "Authorization", "Token token=[access_token]", required: true
  def index
    @judges = JudgeTeam.where( judge_id: params[:judge_id] )

    if @judges.any?
      authorize @judges
    else
      skip_authorization
    end

    render json: @judges, status: :ok
  end

  api :POST, "/judges/:judge_id/teams", "Add a team to a judge. Must be an organizer of the event"
    description "Add a team to a judge"
    error code: :unprocessable_entity, desc: " - Bad parameters for judge"
    error code: :unauthorized, desc: " - Bad Token"
    param :team_id, Integer, desc: "ID of the team you want to add to the judge", required: true
    header "Authorization", "Token token=[access_token]", required: true
  def create
    @team  = EventTeam.find( params[:team_id] )
    @judge = EventJudge.find( params[:judge_id] )

    @judge = JudgeTeam.new( team: @team, judge: @judge )
    authorize @judge

    if @judge.save
      render json: @judge, status: :created
    else
      render json: @judge.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, "/judges/:judge_id/teams/:id", "Remove a team from a judge. Must be an organizer of the event."
    description "Remove a team from a judge"
    error code: :not_found, desc: " - Requested team judge did not exist"
    error code: :unauthorized, desc: " - Bad Token"
    header "Authorization", "Token token=[access_token]", required: true
  def destroy
    @judge = JudgeTeam.find_by( judge_id: params[:judge_id], team_id: params[:id] )
    authorize @judge
    @judge.destroy

    head :ok
  end
end

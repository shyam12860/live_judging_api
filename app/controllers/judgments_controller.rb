class JudgmentsController < ApplicationController
  api :GET, "/events/:event_id/judgments", "Get a list of judgments"
    description "Get a list of all event judgments."
    error code: :unauthorized, desc: " - Bad Token"
    param :judge_id,     Integer, desc: "Judge that a judgment relates to",               required: false
    param :team_id,      Integer, desc: "Team that a judgment relates to",                required: false
    header "Authorization", "Token token=[access_token]", required: true
  def index
    @judgments = Judgment.joins( :team ).joins( :event ).where( events: { id: params[:event_id] } )

    if params[:team_id]
      @judgments = @judgments.where( team: params[:team_id] )
    end

    if params[:judge_id]
      @judgments = @judgments.where( judge: params[:judge_id] )
    end

    if params[:criterion_id]
      @judgments = @judgments.where( criterion: params[:criterion_id] )
    end

    if @judgments.any?
      authorize @judgments
    else
      skip_authorization
    end

    render json: @judgments, status: :ok
  end

  api :GET, "/judgments/:id", "Get a specific judgment"
    description "Get a specific judgment."
    error code: :unauthorized, desc: " - Bad Token"
    header "Authorization", "Token token=[access_token]", required: true
  def show
    @judgment = Judgment.find( params[:id] )
    authorize @judgment

    render json: @judgment, status: :ok
  end

  api :PUT, "/judgments/:id", "Update a judgment. Must be an organizer or judge of the event"
    description "Update a rubric judgment"
    error code: :unprocessable_entity, desc: " - Bad parameters for User"
    error code: :unauthorized, desc: " - Bad Token"
    param :judge_id,     Integer, desc: "Judge that a judgment relates to",               required: false
    param :team_id,      Integer, desc: "Team that a judgment relates to",                required: false
    param :criterion_id, Integer, desc: "Criterion that a judgment relates to",           required: false
    param :value,        String,  desc: "Value that a judge gives a team in a criterion", required: false
    header "Authorization", "Token token=[access_token]", required: true
  def update
    @judgment = Judgment.find( params[:id] )
    authorize @judgment

    if @judgment.update_attributes( my_params )
      render json: @judgment, status: :ok
    else
      render json: @judgment.errors, status: :unprocessable_entity
    end
  end

  api :POST, "/judgments", "Add a judgment. Must be an organizer or judge of the event"
    description "Add a rubric to a judgment"
    error code: :unprocessable_entity, desc: " - Bad parameters for Judgment"
    error code: :unauthorized, desc: " - Bad Token"
    param :judge_id,     Integer, desc: "Judge that a judgment relates to",               required: true
    param :team_id,      Integer, desc: "Team that a judgment relates to",                required: true
    param :criterion_id, Integer, desc: "Criterion that a judgment relates to",           required: true
    param :value,        String,  desc: "Value that a judge gives a team in a criterion", required: true
    header "Authorization", "Token token=[access_token]", required: true
  def create
    @judge = EventJudge.find( params[:judge_id] )
    @team = EventTeam.find( params[:team_id] )
    @criterion = Criterion.find( params[:criterion_id] )

    @judgment = Judgment.new( value: params[:value], criterion: @criterion, team: @team, judge: @judge )
    authorize @judgment

    if @judgment.save
      render json: @judgment, status: :created
    else
      render json: @judgment.errors, status: :unprocessable_entity
    end
  end

  private
    def my_params
      params.permit( :value, :judge_id, :team_id, :criterion_id )
    end
end

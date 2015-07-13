class CriteriaController < ApplicationController
  api :GET, "/rubrics/:rubric_id/criteria", "Get a list of rubric criteria"
    description "Get a list of all rubric criteria."
    error code: :unauthorized, desc: " - Bad Token"
    header "Authorization", "Token token=[access_token]", required: true
  def index
    @criteria = Rubric.find( params[:rubric_id] ).criteria

    if @criteria.any?
      authorize @criteria
    else
      skip_authorization
    end

    render json: @criteria, status: :ok
  end

  api :GET, "/criteria/:id", "Get a specific rubric criterion"
    description "Get a specific rubric criterion."
    error code: :unauthorized, desc: " - Bad Token"
    header "Authorization", "Token token=[access_token]", required: true
  def show
    @criterion = Criterion.find( params[:id] )
    authorize @criterion

    render json: @criterion, status: :ok
  end

  api :PUT, "/criteria/:id", "Update a criterion. Must be an organizer of the event"
    description "Update a criterion"
    error code: :unprocessable_entity, desc: " - Bad parameters for User"
    error code: :unauthorized, desc: " - Bad Token"
    param :label,     String,  desc: "Criterion label", required: false
    param :min_score, Integer, desc: "Minimum score a judge can give this criterion", required: false
    param :max_score, Integer, desc: "Maximum score a judge can give this criterion", required: false
    header "Authorization", "Token token=[access_token]", required: true
  def update
    @criterion = Criterion.find( params[:id] )
    authorize @criterion

    if @criterion.update_attributes( my_params )
      render json: @criterion, status: :ok
    else
      render json: @criterion.errors, status: :unprocessable_entity
    end
  end

  api :POST, "/rubrics/:rubric_id/criteria", "Add a criterion to a rubric. Must be an organizer of the event"
    description "Add a rubric to a criterion"
    error code: :unprocessable_entity, desc: " - Bad parameters for Criterion"
    error code: :unauthorized, desc: " - Bad Token"
    param :label,     String,  desc: "The label for this criterion",                                          required: true
    param :min_score, Integer, desc: "The minimum value a judge can score for this criterion. Defaults to 0", required: false
    param :max_score, Integer, desc: "The maximum value a judge can score for this criterion. Defaults to 5", required: false
    header "Authorization", "Token token=[access_token]", required: true
  def create
    @rubric = Rubric.find( params[:rubric_id] )
    @criterion = @rubric.criteria.new( my_params )
    authorize @criterion

    if @criterion.save
      render json: @criterion, status: :created
    else
      render json: @criterion.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, "/criteria/:id", "Remove a criterion. Must be an organizer of the event."
    description "Remove a criterion"
    error code: :not_found, desc: " - Requested rubric criterion did not exist"
    error code: :unauthorized, desc: " - Bad Token"
    header "Authorization", "Token token=[access_token]", required: true
  def destroy
    @criterion = Criterion.find( params[:id] )
    authorize @criterion
    @criterion.destroy

    head :ok
  end

  private
    def my_params
      params.permit( :label, :min_score, :max_score )
    end
end

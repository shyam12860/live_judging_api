class RubricsController < ApplicationController
  api :GET, "/events/:event_id/rubrics", "Get a list of event rubrics"
    description "Get a list of all rubrics for an event."
    error code: :unauthorized, desc: " - Bad Token"
    header "Authorization", "Token token=[access_token]", required: true
  def index
    @rubrics = Rubric.where( event_id: params[:event_id] )
    authorize @rubrics

    render json: @rubrics, status: :ok
  end

  api :GET, "/rubrics/:id", "Get a rubric. Must be an organizer of the event it belongs to"
    description "Show an event rubric."
    error code: :not_found, desc: " - rubric not found in system"
    error code: :unauthorized, desc: " - Bad Token"
    header "Authorization", "Token token=[access_token]", required: true
  def show
    @rubric = Rubric.find( params[:id] )
    authorize @rubric

    render json: @rubric, status: :ok
  end

  api :POST, "/events/:event_id/rubrics", "Create a new event rubric. Must be an organizer of the event"
    description "Create a new rubric for an event."
    error code: :unprocessable_entity, desc: " - Bad parameters for User"
    error code: :unauthorized, desc: " - Bad Token"
    param :name, String, desc: "rubric name", required: true
    header "Authorization", "Token token=[access_token]", required: true
  def create
    @rubric = Rubric.new( create_params )
    authorize @rubric

    if @rubric.save
      render json: @rubric, status: :created
    else
      render json: @rubric.errors, status: :unprocessable_entity
    end
  end

  api :PUT, "/rubrics/:id", "Update an event rubric. Must be an organizer of the event"
    description "Update an event rubric."
    error code: :unprocessable_entity, desc: " - Bad parameters for User"
    error code: :unauthorized, desc: " - Bad Token"
    param :name, String, desc: "rubric name", required: true
    header "Authorization", "Token token=[access_token]", required: true
  def update
    @rubric = Rubric.find( params[:id] )
    authorize @rubric

    if @rubric.update_attributes( update_params )
      render json: @rubric, status: :ok
    else
      render json: @rubric.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, "/rubrics/:id", "Delete an event rubric. Must be an organizer of the event."
    description "Delete an event rubric."
    error code: :not_found, desc: " - Requested event rubric did not exist"
    error code: :unauthorized, desc: " - Bad Token"
    header "Authorization", "Token token=[access_token]", required: true
  def destroy
    @rubric = Rubric.find( params[:id] )
    authorize @rubric
    @rubric.destroy

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

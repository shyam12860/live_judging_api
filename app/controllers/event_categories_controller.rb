class EventCategoriesController < ApplicationController

  api :GET, "/events/:event_id/categories", "Get a list of event categories"
    description "Get a list of all categories for an event."
    error code: :unauthorized, desc: " - Bad Token"
    header "Authorization", "Token token=[access_token]", required: true
  def index
    @categories = EventCategory.where( event_id: params[:event_id] )

    if @categories.any?
      authorize @categories
    else
      skip_authorization
    end

    render json: @categories, status: :ok
  end

  api :POST, "/events/:event_id/categories", "Create a new event category. Must be an organizer of the event"
    description "Create a new category for an event."
    error code: :unprocessable_entity, desc: " - Bad parameters for User"
    error code: :unauthorized, desc: " - Bad Token"
    param :label, String, desc: "Category label", required: true
    param :color, Integer, desc: "Integer value for a color", required: true
    param :due_at, String, desc: "Datetime that judging for this category is due at", required: false
    param :description, String, desc: "Description of the category", required: false
    param :rubric_id, Integer, desc: "The rubric to grade this category with", required: false
    header "Authorization", "Token token=[access_token]", required: true
  def create
    @category = EventCategory.new( create_params )
    authorize @category

    if @category.save
      render json: @category, status: :created
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  api :GET, "/categories/:id", "Get a category. Must be an organizer of the event it belongs to"
    description "Show an event category."
    error code: :not_found, desc: " - Category not found in system"
    error code: :unauthorized, desc: " - Bad Token"
    header "Authorization", "Token token=[access_token]", required: true
  def show
    @category = EventCategory.find( params[:id] )
    authorize @category

    render json: @category, status: :ok
  end

  api :PUT, "/categories/:id", "Update an event category. Must be an organizer of the event"
    description "Update an event category."
    error code: :unprocessable_entity, desc: " - Bad parameters for User"
    error code: :unauthorized, desc: " - Bad Token"
    param :label, String, desc: "Category label", required: true
    param :color, Integer, desc: "Integer value for a color", required: true
    param :due_at, String, desc: "Datetime that judging for this category is due at", required: false
    param :description, String, desc: "Description of the category", required: false
    param :rubric_id, Integer, desc: "The rubric to grade this category with", required: false
    header "Authorization", "Token token=[access_token]", required: true
  def update
    @category = EventCategory.find( params[:id] )
    authorize @category

    if @category.update_attributes( update_params )
      render json: @category, status: :ok
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, "/categories/:id", "Delete an event category. Must be an organizer of the event."
    description "Delete an event category."
    error code: :not_found, desc: " - Requested event category did not exist"
    error code: :unauthorized, desc: " - Bad Token"
    header "Authorization", "Token token=[access_token]", required: true
  def destroy
    @category = EventCategory.find( params[:id] )
    authorize @category
    @category.destroy

    head :ok
  end

  private
    def create_params
      params.permit( :event_id, :label, :color, :description, :due_at, :rubric_id )
    end
    
    def update_params
      params.permit( :label, :color, :description, :due_at, :rubric_id  )
    end
end

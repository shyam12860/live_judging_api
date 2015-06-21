class EventCategoriesController < ApplicationController

  api :GET, "/event/:event_id/categories", "Get a list of event categories"
    description "Get a list of all categories for an event."
    error code: :unauthorized, desc: " - Bad Token"
    header "Authorization", "Token token=[access_token]", required: true
  def index
    @categories = EventCategory.where( event_id: params[:event_id] )
    authorize @categories

    render json: @categories, status: :ok
  end

  api :POST, "/events/:event_id/categories", "Create a new event category. Must be an organizer of the event"
    description "Create a new category for an event."
    error code: :unprocessable_entity, desc: " - Bad parameters for User"
    error code: :unauthorized, desc: " - Bad Token"
    param :label, String, desc: "Category label", required: true
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

  api :PUT, "/event_categories/:id", "Update an event category. Must be an organizer of the event"
    description "Update an event category."
    error code: :unprocessable_entity, desc: " - Bad parameters for User"
    error code: :unauthorized, desc: " - Bad Token"
    param :label, String, desc: "Category label", required: true
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

  api :DELETE, "/event_categories/:id", "Delete an event category. Must be an organizer of the event."
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
      params.permit( :event_id, :label )
    end
    
    def update_params
      params.permit( :label )
    end
end

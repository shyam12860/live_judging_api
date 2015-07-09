class RubricCategoriesController < ApplicationController
  api :GET, "/rubrics/:rubric_id/categories", "Get a list of rubric categories"
    description "Get a list of all rubric categories."
    error code: :unauthorized, desc: " - Bad Token"
    header "Authorization", "Token token=[access_token]", required: true
  def index
    @categories = RubricCategory.where( rubric_id: params[:rubric_id] )

    if @categories.any?
      authorize @categories
    else
      skip_authorization
    end

    render json: @categories, status: :ok
  end

  api :POST, "/rubrics/:rubric_id/categories", "Add a rubric to a category. Must be an organizer of the event"
    description "Add a rubric to a category"
    error code: :unprocessable_entity, desc: " - Bad parameters for Category"
    error code: :unauthorized, desc: " - Bad Token"
    param :category_id, Integer, desc: "ID of the category you want to add the rubric to", required: true
    header "Authorization", "Token token=[access_token]", required: true
  def create
    @rubric = Rubric.find( params[:rubric_id] )
    @category = EventCategory.find( params[:category_id] )

    @rubric_category = RubricCategory.new( rubric: @rubric, category: @category )
    authorize @rubric_category

    if @rubric_category.save
      render json: @rubric_category, status: :created
    else
      render json: @rubric_category.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, "/rubrics/:rubric_id/categories/:id", "Remove a rubric from a category. Must be an organizer of the event."
    description "Remove a rubric from a category"
    error code: :not_found, desc: " - Requested rubric category did not exist"
    error code: :unauthorized, desc: " - Bad Token"
    header "Authorization", "Token token=[access_token]", required: true
  def destroy
    @rubric_category = RubricCategory.find_by( rubric_id: params[:rubric_id], category_id: params[:id] )
    authorize @rubric_category
    @rubric_category.destroy

    head :ok
  end
end

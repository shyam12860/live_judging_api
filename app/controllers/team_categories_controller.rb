class TeamCategoriesController < ApplicationController
  api :GET, "/teams/:team_id/categories", "Get a list of team categories"
    description "Get a list of all team categories."
    error code: :unauthorized, desc: " - Bad Token"
    header "Authorization", "Token token=[access_token]", required: true
  def index
    @categories = TeamCategory.where( team_id: params[:team_id] )

    if @categories.any?
      authorize @categories
    else
      skip_authorization
    end

    render json: @categories, status: :ok
  end

  api :POST, "/teams/:team_id/categories", "Add a team to a category. Must be an organizer of the event"
    description "Add a team to a category"
    error code: :unprocessable_entity, desc: " - Bad parameters for Category"
    error code: :unauthorized, desc: " - Bad Token"
    param :category_id, Integer, desc: "ID of the category you want to add the team to", required: true
    header "Authorization", "Token token=[access_token]", required: true
  def create
    @category = TeamCategory.new( create_params )
    authorize @category

    if @category.save
      render json: @category, status: :created
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, "/teams/:team_id/categories/:id", "Remove a team from a category. Must be an organizer of the event."
    description "Remove a team from a category"
    error code: :not_found, desc: " - Requested team category did not exist"
    error code: :unauthorized, desc: " - Bad Token"
    header "Authorization", "Token token=[access_token]", required: true
  def destroy
    @category = TeamCategory.find_by( team_id: params[:team_id], category_id: params[:id] )
    authorize @category
    @category.destroy

    head :ok
  end

  private
    def create_params
      params.permit( :team_id, :category_id )
    end
end

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

  api :GET, "/team_categories/:id", "Get a specific team category"
    description "Get a specific team category"
    error code: :unauthorized, desc: " - Bad Token"
    header "Authorization", "Token token=[access_token]", required: true
  def show
    @team_category = TeamCategory.find( params[:id] )
    authorize @team_category

    render json: @team_category, status: :ok
  end


  api :POST, "/teams/:team_id/categories", "Add a team to a category. Must be an organizer of the event"
    description "Add a team to a category"
    error code: :unprocessable_entity, desc: " - Bad parameters for Category"
    error code: :unauthorized, desc: " - Bad Token"
    param :category_id, Integer, desc: "ID of the category you want to add the team to", required: true
    header "Authorization", "Token token=[access_token]", required: true
  def create
    @team = EventTeam.find( params[:team_id] )
    @category = EventCategory.find( params[:category_id] )

    @team_category = TeamCategory.new( team: @team, category: @category )
    authorize @team_category

    if @team_category.save
      render json: @team_category, status: :created
    else
      render json: @team_category.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, "/teams/:team_id/categories/:id", "Remove a team from a category. Must be an organizer of the event."
    description "Remove a team from a category"
    error code: :not_found, desc: " - Requested team category did not exist"
    error code: :unauthorized, desc: " - Bad Token"
    header "Authorization", "Token token=[access_token]", required: true
  def destroy
    @team_category = TeamCategory.find_by( team_id: params[:team_id], category_id: params[:id] )
    authorize @team_category
    @team_category.destroy

    head :ok
  end
end

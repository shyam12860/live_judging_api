class RolesController < ApplicationController

  api :GET, "/roles/:id", "Get a specific role"
    description "Get a specific role by its id"
    error code: :not_found, desc: " - Role not found in system"
    error code: :unauthorized, desc: " - Bad Token"
    header "Authorization", "Token token=[access_token]", required: true
  def show
    @role = Role.find( params[:id] )
    authorize @role

    render json: @role, status: :ok
  end

  api :GET, "/roles", "Get a list of roles"
    description "Get a list of all roles"
    error code: :unauthorized, desc: " - Bad Token"
    header "Authorization", "Token token=[access_token]", required: true
  def index
    @roles = policy_scope( Role )
    authorize @roles

    render json: @roles, status: :ok
  end
end

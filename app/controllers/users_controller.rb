class UsersController < ApplicationController
  skip_before_action :authenticate, only: [ :create ]

  api :POST, "/users", "Create a new user"
    description "Create a new user for the application."
    error code: :unprocessable_entity, desc: " - Bad parameters for User"
    error code: :unauthorized, desc: " - Bad Token"
    param :email,                 String, desc: "User Email Address",         required: true
    param :password,              String, desc: "User password",              required: true
    param :password_confirmation, String, desc: "User Password Confirmation", required: true
    param :first_name,            String, desc: "User First Name",            required: true
    param :last_name,             String, desc: "User Last Name",             required: true
  def create
    @user = User.new( my_params )
    authorize @user

    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  api :PUT, "/users/:id", "Update a specific user"
    description "Update a specific user by their id"
    error code: :unprocessable_entity, desc: " - Bad parameters for User"
    error code: :unauthorized, desc: " - Bad Token"
    param :email,                 String, desc: "User Email Address",                      required: false
    param :password,              String, desc: "User password",                           required: false
    param :password_confirmation, String, desc: "User Password Confirmation",              required: false
    param :first_name,            String, desc: "User First Name",                         required: false
    param :last_name,             String, desc: "User Last Name",                          required: false
    header "Authorization", "Token token=[access_token]", required: true
  def update
    @user = User.find( params[:id] )
    authorize @user

    if @user.update_attributes( my_params )
      render json: @user, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  api :GET, "/users", "Get a list of users"
    description "Get a list of all users for the application"
    error code: :unauthorized, desc: " - Bad Token"
    header "Authorization", "Token token=[access_token]", required: true
  def index
    @users = policy_scope( User )
    authorize @users
    render json: @users, status: :ok
  end

  api :GET, "/users/:id", "Get a specific user"
    description "Get a specific user by their id"
    error code: :not_found, desc: " - User not found in system"
    error code: :unauthorized, desc: " - Bad Token"
    header "Authorization", "Token token=[access_token]", required: true
  def show
    @user = User.find( params[:id] )
    authorize @user

    render json: @user, status: :ok
  end

  private
  def my_params
    params.permit( :first_name, :last_name, :email, :password, :password_confirmation )
  end
end

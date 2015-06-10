class UsersController < ApplicationController
  skip_before_action :authenticate, only: [ :create ]

  api :POST, "/users", "Create a new user"
    description "Create a new user for the application"
    error code: :unprocessable_entity, desc: " - Bad parameters for User"
    error code: :unauthorized, desc: " - Bad Token"
    param :user, Hash, show: false do
      param :email, String, desc: "User Email Address", required: true
      param :password, String, desc: "User password", required: true
      param :password_confirmation, String, desc: "User Password Confirmation", required: true
      param :first_name, String, desc: "User First Name", required: true
      param :last_name, String, desc: "User Last Name", required: true
    end
    header "Authorization", "Token token=[access_token]", required: true
  def create
    @user = User.new( create_params )

    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  api :GET, "/users", "Get a list of users"
    description "Get a list of all users for the application"
    error code: :unauthorized, desc: " - Bad Token"
    header "Authorization", "Token token=[access_token]", required: true
  def index
    @users = User.all
    render json: @users
  end

  private
    def create_params
      params.require( :user ).permit( :first_name, :last_name, :password, :password_confirmation, :email )
    end
end

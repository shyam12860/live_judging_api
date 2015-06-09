class UsersController < ApplicationController
  skip_before_action :authenticate, only: [ :create ]

  api!
  def create
    @user = User.new( create_params )

    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  api!
  def index
    @users = User.all
    render json: @users
  end

  private
    def create_params
      params.require( :user ).permit( :first_name, :last_name, :password, :email )
    end
end

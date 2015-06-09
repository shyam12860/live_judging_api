class SessionsController < ApplicationController
  skip_before_action :authenticate

  api!
  def create
    if params[:email]
      @user = User.where( email: params[:email] ).first

      if provided_valid_password || provided_valid_api_key
        render json: @user, status: :ok
      else
        render json: "Unauthorized", status: :unauthorized
      end
    end
  end

  api!
  def destroy
    if params[:email]
      @user = User.where( email: params[:email] ).first

      if provided_valid_password || provided_valid_api_key
        @user.token.destroy
        head :no_content
      else
        render json: "Unauthorized", status: :unauthorized
      end
    end
  end

  private
    def provided_valid_password
      params[:password] && @user && BCrypt::Password.new( @user.password ) == params[:password]
    end

    def provided_valid_api_key
      params[:api_key] && @user && @user.token.api_key == params[:api_key]
    end
end

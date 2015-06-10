class SessionsController < ApplicationController
  skip_before_action :authenticate, only: :create
  before_action :authenticate_basic, only: :create

  api :GET, "/login", "Returns a user and its token"
    error code: :unauthorized, desc: " - Bad Base64 email:password"
  def create
    @user.set_auth_token
    render json: @user, status: :ok
  end

  api! "Uses HTTP Token Authentication"
  def destroy
    @user.token.destroy
    head :no_content
  end

  private
    def authenticate_basic
      authenticate_basic_auth || render_unauthorized_basic
    end

    def authenticate_basic_auth
      authenticate_with_http_basic do |email, password|
        @user = User.where( email: email ).first
        User.authenticate( email, password )
      end
    end

    def render_unauthorized_basic
      render json: 'Bad credentials. Username/Password required.', status: :unauthorized
    end
end

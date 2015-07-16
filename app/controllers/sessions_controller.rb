class SessionsController < ApplicationController
  skip_before_action :authenticate, only: :create
  before_action :authenticate_basic, only: :create
  before_action :skip_authorization

  api :GET, "/login", "Returns a user and its token"
    description "Returns User JSON object on success, error on failure"
    param :platform, String, desc: "Which platform the user is logging in from. 'iOS', 'Android', or 'Web'", required: true
    error code: :unauthorized, desc: " - Bad Base64 email:password"
    header "Authorization", "Basic [Base64 email:password]", required: true
  def create
    if params[:platform]
      @platform = Platform.find_by( label: params[:platform] )

      if @platform
        @user.set_auth_token
        @user.platform = @platform
        @user.save

        render json: @user, status: :ok
      else
        render json: "Must provide a valid platform", status: :unauthorized
      end
    else
      render json: "Must provide a platform", status: :unauthorized
    end
  end

  api :GET, "/logout", "Uses HTTP Token Authentication"
    description "Returns no content and an 'OK' status on success, error on failure"
    error code: :unauthorized, desc: " - Bad Token"
    header "Authorization", "Token token=[access_token]", required: true
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
      headers["WWW-Authenticate"] = %(Basic realm="Live Judging")
      render json: 'Bad credentials. Email/Password required.', status: :unauthorized
    end
end

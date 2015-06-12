class ApplicationController < ActionController::API
  include ActionController::Serialization
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  before_action :authenticate

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  protected
    def authenticate
      authenticate_token || render_unauthorized
    end

    def authenticate_token
      authenticate_with_http_token do |token|
        token = Token.where( access_token: token ).first
        token && @user = token.user
      end
    end

    def render_unauthorized
      render json: 'Bad credentials. Token required.', status: :unauthorized
    end

    def record_not_found
      head :not_found
    end
end

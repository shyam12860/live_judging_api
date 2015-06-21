class ApplicationController < ActionController::API
  include ActionController::Serialization
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  include Pundit

  before_action :authenticate
  after_action :verify_authorized, except: :index

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from Pundit::NotDefinedError, with: :record_not_found

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
      render json: "Bad credentials. Token required.", status: :unauthorized
    end

    def current_user
      authenticate_with_http_token do |token|
        token = Token.find_by( access_token: token )
        if token
          token.user  
        else
          nil
        end
      end
    end

    def record_not_found
      head :not_found
    end

    def user_not_authorized
      head :unauthorized
    end
end

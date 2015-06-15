class ApplicationController < ActionController::API
  include ActionController::Serialization
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  include Pundit

  before_action :authenticate
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index
  before_filter :cors_preflight_check
  after_filter :cors_set_access_control_headers

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token'
    headers['Access-Control-Max-Age'] = "1728000" 
  end

  def cors_preflight_check
    if request.method == 'OPTIONS'
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version, Token'
      headers['Access-Control-Max-Age'] = '1728000'
 
      render :text => '', :content_type => 'text/plain'
    end
  end

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

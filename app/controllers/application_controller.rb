class ApplicationController < ActionController::API
  include ActionController::Serialization
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  include Pundit

  before_action :authenticate
  after_action :verify_authorized, except: :index

  before_filter :cors_preflight_check
  before_filter :allow_cross_domain_access
  after_filter :set_cors_access_control

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
      headers["WWW-Authenticate"] = %(Basic realm="Live Judging")
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
      headers["WWW-Authenticate"] = %(Basic realm="Pundit")
      head :unauthorized
    end

    def parse_image_data( base64_image )
      filename = "upload-image"
      in_content_type, encoding, string = base64_image.split( /[:;,]/ )[1..3]
      StringIO.new( Base64.decode64( string ) )
    end

    def cors_preflight_check
      if request.method == :options
        headers['Access-Control-Allow-Origin'] = '*'
        headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
        headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version'
        headers['Access-Control-Max-Age'] = '1728000'
        render :text => '', :content_type => 'text/plain'
      end
    end

    def set_cors_access_control
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
      headers['Access-Control-Allow-Headers'] = %w{Origin Accept Content-Type X-Requested-With X-CSRF-Token}.join(',')
      headers['Access-Control-Max-Age'] = "1728000"
    end

    def allow_cross_domain_access
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = %w{Origin Accept Content-Type X-Requested-With X-CSRF-Token}.join(',')
      headers['Access-Control-Allow-Headers'] = 'GET, POST, PUT, DELETE, OPTIONS'
      headers['Access-Control-Max-Age'] = '1728000'
    end
end

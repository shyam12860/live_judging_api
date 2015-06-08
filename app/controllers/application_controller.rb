class ApplicationController < ActionController::API
  include ActionController::Serialization
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include Authenticatable

  before_action :authenticate

  protected
    def authenticate
      authenticate_token || render_unauthorized
    end

    def authenticate_token
      authenticate_with_http_token do |token|
        User.find_by( token: token )
      end
    end

    def render_unauthorized
      self.headers['WWW-Authenticate'] = 'Token realm="Zombies"'

      render json: 'Bad credentials', status: :unauthorized
    end
end

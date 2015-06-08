module Authenticatable
  def current_user
    @current_user ||= User.find_by( token: request.headers['Authorization'] )
  end

  def authenticate_with_token!
    unless current_user.present?
      render json: "Not authenticated", status: :unauthorized
    end
  end
end

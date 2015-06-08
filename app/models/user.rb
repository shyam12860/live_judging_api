class User < ActiveRecord::Base
  before_create :set_auth_token

  has_one :token

  private
    
    def set_auth_token
      return if self.token.present?
      self.token = Token.create
    end
end

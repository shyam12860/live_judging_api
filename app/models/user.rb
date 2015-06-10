class User < ActiveRecord::Base
  has_secure_password

  after_create :set_auth_token

  has_one :token

  validates :email,
    presence: true,
    email: true,
    uniqueness: true

  validates :password_digest,
    presence: true

  validates :first_name,
    presence: true

  validates :last_name,
    presence: true

  def self.authenticate( email, password )
    user = find_by( email: email)
    user && user.authenticate( password )
  end

  def set_auth_token
    return if self.token.present?

    Token.create( user: self )
  end
end

class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_secure_password

  after_create :set_auth_token

  has_one :token

  validates :email,
    presence: true,
    email: true,
    uniqueness: true

  validates :password_digest,
    presence: true

  validates :password,
    presence: true,
    length: { minimum: 6 }

  validates :password_confirmation,
    presence: true,
    length: { minimum: 6 }

  validates :first_name,
    presence: true

  validates :last_name,
    presence: true

  def name
    [first_name, last_name].join " "
  end

  def self.authenticate( email, password )
    user = find_by( email: email)
    user && user.authenticate( password )
  end

  # Make sure that we get a token after the user is created
  def set_auth_token
    return if self.token.present?

    Token.create( user: self )
  end

  # FriendlyID Strings made more pretty
  def normalize_friendly_id( string )
    super.gsub( "-", "_" )
  end

end

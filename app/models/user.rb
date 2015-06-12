class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_secure_password

  after_create :set_auth_token
  before_validation :set_default_role, on: :create

  has_one :token
  belongs_to :role

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

  validates :role,
    presence: true

  def name
    [first_name, last_name].join " "
  end

  def admin?
    role == Role.find_by_label( 'admin' )
  end

  def organizer?
    role == Role.find_by_label( 'organizer' )
  end

  def judge?
    role == Role.find_by_label( 'judge' )
  end

  def self.authenticate( email, password )
    user = find_by( email: email)
    user && user.authenticate( password )
  end

  # FriendlyID Strings made more pretty
  def normalize_friendly_id( string )
    super.gsub( "-", "_" )
  end

  def set_auth_token
    return if self.token.present?

    Token.create( user: self )
  end

  private
    def set_default_role
      self.role ||= Role.find_by_label( 'organizer' )
    end
end

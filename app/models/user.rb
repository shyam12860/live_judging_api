class User < ActiveRecord::Base
  has_secure_password

  after_create :set_auth_token
  after_initialize :init

  has_one :token
  has_many :organized_events, class_name: "Event", foreign_key: "organizer_id"
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

  def set_auth_token
    return if self.token.present?

    Token.create( user: self )
  end

  private
    def init
      self.role ||= Role.find_by_label( 'organizer' )
    end
end

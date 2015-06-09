class User < ActiveRecord::Base
  before_create :set_auth_token

  has_one :token

  validates :email,
    presence: true,
    email: true,
    uniqueness: true

  validates :password,
    presence: true,
    length: { minimum: 4 }

  validates :first_name,
    presence: true

  validates :last_name,
    presence: true

  def password=(secret)
    write_attribute( :password, BCrypt::Password.create( secret ) )
  end

  private
    
    def set_auth_token
      return if self.token.present?
      Token.create!.user = self
    end
end

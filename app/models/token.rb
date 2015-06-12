class Token < ActiveRecord::Base
  before_validation :generate_access_token, on: :create

  belongs_to :user

  validates :access_token,
    presence: true

  validates :expires_at,
    presence: true

  validates :user,
    presence: true

  private
    def generate_access_token
      begin
        self.access_token = SecureRandom.hex
      end while self.class.exists?( access_token: access_token )
    end
end
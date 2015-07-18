# == Schema Information
#
# Table name: tokens
#
#  id           :integer          not null, primary key
#  access_token :string           not null
#  expires_at   :datetime         default(Sat, 01 Aug 2015 01:47:47 UTC +00:00), not null
#  user_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

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

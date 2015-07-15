# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  first_name      :string           not null
#  last_name       :string           not null
#  admin           :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  platform_id     :integer
#

class User < ActiveRecord::Base
  has_secure_password

  after_create :set_auth_token

  has_one :token
  belongs_to :platform
  has_many :event_organizers, foreign_key: "organizer_id", dependent: :destroy
  has_many :organized_events, through: :event_organizers, source: "event"
  has_many :event_judges, foreign_key: "judge_id", dependent: :destroy
  has_many :judged_events, through: :event_judges, source: "event"

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

  def set_auth_token
    return if self.token.present?

    Token.create( user: self )
  end
end

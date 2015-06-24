# == Schema Information
#
# Table name: event_teams
#
#  id         :integer          not null, primary key
#  logo_id    :string
#  name       :string           not null
#  event_id   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class EventTeam < ActiveRecord::Base
  # Associations
  belongs_to :event
  has_many :team_categories, foreign_key: "team_id", dependent: :destroy
  has_many :categories, through: :team_categories
  has_many :judge_teams, foreign_key: "team_id", dependent: :destroy
  has_many :judges, through: :judge_teams

  # Refile
  attachment :logo

  # Validations
  validates :name,
    presence: true,
    uniqueness: { scope: :event }

  validates :event,
    presence: true
end

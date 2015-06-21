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

  # Refile
  attachment :logo, type: :image

  # Validations
  validates :name,
    presence: true,
    uniqueness: { scope: :event }

  validates :event,
    presence: true
end

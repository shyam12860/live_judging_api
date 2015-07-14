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

class EventTeamSerializer < ActiveModel::Serializer
  attributes :id, :name

  belongs_to :event
  has_many :categories
  has_many :judges

  def logo
    "https://s3.amazonaws.com/live-judging/store/#{logo_id}"
  end
end

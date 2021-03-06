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
  attributes :id, :name, :logo

  belongs_to :event
  has_many :categories
  has_many :judges

  def logo
    if object.logo_id
      "https://s3.amazonaws.com/live-judging/store/#{object.logo_id}"
    end
  end
end

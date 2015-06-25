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
  attributes :id, :event, :name, :logo

  has_many :categories
  has_many :judges

  def logo
    Refile.attachment_url( object, :logo, :fill, 300, 300, format: "jpg" )
  end
end

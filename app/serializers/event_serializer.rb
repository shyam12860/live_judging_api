# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  location   :string           not null
#  start_time :datetime         not null
#  end_time   :datetime         not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  map_id     :string
#

class EventSerializer < ActiveModel::Serializer
  attributes :id, :name, :location, :start_time, :end_time, :map

  has_many :judges
  has_many :teams
  has_many :categories

  def start_time
    object.start_time.strftime( "%F %r" )
  end

  def end_time
    object.end_time.strftime( "%F %r" )
  end

  def map
    if object.map_id
      "https://s3.amazonaws.com/live-judging/store/#{object.map_id}"
    end
  end
end

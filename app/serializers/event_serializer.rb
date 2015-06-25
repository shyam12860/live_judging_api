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
#

class EventSerializer < ActiveModel::Serializer
  attributes :id, :name, :location, :start_time, :end_time

  has_many :organizers
  has_many :judges
  has_many :categories
  has_many :teams

  def start_time
    object.start_time.strftime( "%F %r" )
  end

  def end_time
    object.end_time.strftime( "%F %r" )
  end
end

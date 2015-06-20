class EventSerializer < ActiveModel::Serializer
  attributes :id, :name, :location, :start_time, :end_time

  has_many :organizers, embed: :ids
  has_many :judges, embed: :ids

  def start_time
    object.start_time.strftime( "%F %r" )
  end

  def end_time
    object.end_time.strftime( "%F %r" )
  end
end

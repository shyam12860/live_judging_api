class EventSerializer < ActiveModel::Serializer
  attributes :id, :name, :location, :start_time, :end_time

  def start_time
    object.start_time.strftime( "%F %r" )
  end

  def end_time
    object.end_time.strftime( "%F %r" )
  end
end

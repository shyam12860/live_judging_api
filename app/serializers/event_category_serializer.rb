# == Schema Information
#
# Table name: event_categories
#
#  id         :integer          not null, primary key
#  event_id   :integer          not null
#  label      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class EventCategorySerializer < ActiveModel::Serializer
  attributes :id, :event, :label

  def event
    object.event.id
  end
end

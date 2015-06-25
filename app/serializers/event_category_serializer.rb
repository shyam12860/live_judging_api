# == Schema Information
#
# Table name: event_categories
#
#  id          :integer          not null, primary key
#  event_id    :integer          not null
#  label       :string           not null
#  color       :integer          not null
#  due_at      :datetime
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class EventCategorySerializer < ActiveModel::Serializer
  attributes :id, :event, :label, :description, :color, :due_at

  #has_many :teams

  def event
    object.event.id
  end
end

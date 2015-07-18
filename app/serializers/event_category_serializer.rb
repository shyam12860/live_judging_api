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
#  rubric_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class EventCategorySerializer < ActiveModel::Serializer
  attributes :id, :label, :description, :color, :due_at

  belongs_to :event
  belongs_to :rubric
  has_many :teams
end

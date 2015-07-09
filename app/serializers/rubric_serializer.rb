# == Schema Information
#
# Table name: rubrics
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  event_id   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class RubricSerializer < ActiveModel::Serializer
  attributes :id, :name

  def event
    object.event.id
  end
end

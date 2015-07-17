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

  has_many :criteria
  belongs_to :event
  has_many :rubric_categories
end

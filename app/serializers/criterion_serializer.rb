# == Schema Information
#
# Table name: criteria
#
#  id         :integer          not null, primary key
#  label      :string           not null
#  min_score  :integer          default(0), not null
#  max_score  :integer          default(5), not null
#  rubric_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CriterionSerializer < ActiveModel::Serializer
  attributes :id, :label, :min_score, :max_score
end

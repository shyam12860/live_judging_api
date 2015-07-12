# == Schema Information
#
# Table name: rubric_categories
#
#  id          :integer          not null, primary key
#  rubric_id   :integer          not null
#  category_id :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class CriterionSerializer < ActiveModel::Serializer
  attributes :id, :label, :min_score, :max_score
end

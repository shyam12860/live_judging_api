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

class RubricCategory < ActiveRecord::Base
  belongs_to :rubric
  belongs_to :category, class_name: "EventCategory", foreign_key: "category_id"

  validates :rubric,
    presence: true,
    uniqueness: { scope: :category }

  validates :category,
    presence: true
end

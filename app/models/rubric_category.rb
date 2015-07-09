class RubricCategory < ActiveRecord::Base
  belongs_to :rubric
  belongs_to :category, class_name: "EventCategory", foreign_key: "category_id"

  validates :rubric,
    presence: true,
    uniqueness: { scope: :category }

  validates :category,
    presence: true
end

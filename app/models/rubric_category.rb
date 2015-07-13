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

  validate :events_must_match, if: "rubric_id && category_id"

  private
    def events_must_match
      if rubric.event != category.event
        errors.add( :rubric, "event does not match Category event" )
      end
    end
end

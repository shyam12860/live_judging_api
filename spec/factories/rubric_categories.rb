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

FactoryGirl.define do
  factory :rubric_category do
    rubric
    association :category, factory: :event_category

    after :build do |rubric_category|
      rubric_category.category.event = rubric_category.rubric.event
    end
  end
end

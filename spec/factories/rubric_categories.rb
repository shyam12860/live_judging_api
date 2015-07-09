FactoryGirl.define do
  factory :rubric_category do
    rubric
    association :category, factory: :event_category
  end
end

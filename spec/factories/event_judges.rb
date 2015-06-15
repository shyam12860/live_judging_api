FactoryGirl.define do
  factory :event_judge do
    event
    association :judge, factory: :user
  end
end

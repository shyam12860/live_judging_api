FactoryGirl.define do
  factory :event_organizer do
    event
    association :organizer, factory: :user
  end
end

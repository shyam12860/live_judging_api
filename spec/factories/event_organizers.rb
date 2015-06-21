# == Schema Information
#
# Table name: event_organizers
#
#  id           :integer          not null, primary key
#  event_id     :integer          not null
#  organizer_id :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryGirl.define do
  factory :event_organizer do
    event
    association :organizer, factory: :user
  end
end

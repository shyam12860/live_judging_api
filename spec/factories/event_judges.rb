# == Schema Information
#
# Table name: event_judges
#
#  id       :integer          not null, primary key
#  event_id :integer          not null
#  judge_id :integer          not null
#

FactoryGirl.define do
  factory :event_judge do
    event
    association :judge, factory: :user
  end
end

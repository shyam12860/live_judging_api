# == Schema Information
#
# Table name: event_categories
#
#  id         :integer          not null, primary key
#  event_id   :integer          not null
#  label      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :event_category do
    event
    label { Faker::Company.name }
  end
end

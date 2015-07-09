# == Schema Information
#
# Table name: rubrics
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  event_id   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :rubric do
    name { Faker::Company.name }
    event
  end
end

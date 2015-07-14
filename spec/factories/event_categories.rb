# == Schema Information
#
# Table name: event_categories
#
#  id          :integer          not null, primary key
#  event_id    :integer          not null
#  label       :string           not null
#  color       :integer          not null
#  due_at      :datetime
#  description :string
#  rubric_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :event_category do
    event
    rubric
    label       { Faker::Company.name   }
    description { Faker::Lorem.sentence }
    due_at      { Faker::Time.between( Time.now, 4.hours.from_now ) }
    color       { Faker::Number.number( 6 ) }

    after :build do |event_category|
      event_category.rubric.event = event_category.event
    end

    after :create do |event_category|
      event_category.rubric.event = event_category.event
    end
  end
end

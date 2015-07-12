# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  label      :string           not null
#  min_score  :integer          default(0), not null
#  max_score  :integer          default(5), not null
#  rubric_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :criterion do
    label { Faker::Company.name }
    min_score { Faker::Number.between( 0, 5 )   }
    max_score { Faker::Number.between( 6, 100 ) }
    rubric
  end
end

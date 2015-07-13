# == Schema Information
#
# Table name: judgments
#
#  id           :integer          not null, primary key
#  value        :string           not null
#  team_id      :integer          not null
#  judge_id     :integer          not null
#  criterion_id :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryGirl.define do
  factory :judgment do
    association :judge, factory: :event_judge
    association :team, factory: :event_team
    criterion
    value { Faker::Number.between( criterion.min_score, criterion.max_score ) }
  end
end

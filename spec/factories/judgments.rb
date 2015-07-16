# == Schema Information
#
# Table name: judgments
#
#  id           :integer          not null, primary key
#  value        :integer          not null
#  team_id      :integer          not null
#  judge_id     :integer          not null
#  criterion_id :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryGirl.define do
  factory :judgment do
    criterion
    association :judge, factory: :event_judge
    association :team, factory: :event_team
    value { Faker::Number.between( criterion.min_score + 1, criterion.max_score - 1 ) }

    after :create do |judgment|
      judgment.judge.event = judgment.criterion.rubric.event
      judgment.team.event = judgment.criterion.rubric.event
    end

    after :build do |judgment|
      judgment.judge.event = judgment.criterion.rubric.event
      judgment.team.event = judgment.criterion.rubric.event
    end
  end
end

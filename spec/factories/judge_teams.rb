# == Schema Information
#
# Table name: judge_teams
#
#  id         :integer          not null, primary key
#  judge_id   :integer          not null
#  team_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :judge_team do
    after( :create ) { |team_judge| team_judge.judge.event = team_judge.team.event  }
    after( :build  ) { |team_judge| team_judge.judge.event = team_judge.team.event  }

    association :team,  factory: :event_team
    association :judge, factory: :event_judge
  end
end

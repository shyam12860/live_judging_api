FactoryGirl.define do
  factory :team_category do
    after( :create ) { |team_category| team_category.category.event = team_category.team.event  }
    after( :build  ) { |team_category| team_category.category.event = team_category.team.event  }

    association :team,     factory: :event_team
    association :category, factory: :event_category
  end
end

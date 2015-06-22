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

require 'rails_helper'

RSpec.describe JudgeTeam, type: :model do
  let( :judge_team ) { create( :judge_team ) }

  it "has a valid factory" do
    expect( judge_team ).to be_valid
  end

  it "is invalid without a judge" do
    judge_team.judge = nil
    judge_team.valid?
    expect( judge_team.errors[:judge] ).to include( "can't be blank" )
  end

  it "is invalid without a team" do
    judge_team.team = nil
    judge_team.valid?
    expect( judge_team.errors[:team] ).to include( "can't be blank" )
  end

  it "is invalid without a unique team" do
    dup_judge_team = build( :judge_team, team: judge_team.team, judge: judge_team.judge )
    dup_judge_team.valid?
    expect( dup_judge_team.errors[:team] ).to include( "has already been taken" )
  end

  it "is invalid if the team has a different event from the judge" do
    other_team = create( :event_team )
    judge_team.team = other_team
    judge_team.valid?
    expect( judge_team.errors[:team] ).to include( "event does not match Judge event" )
  end
end

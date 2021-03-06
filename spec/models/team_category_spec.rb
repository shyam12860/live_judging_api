# == Schema Information
#
# Table name: team_categories
#
#  id          :integer          not null, primary key
#  team_id     :integer          not null
#  category_id :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe TeamCategory, type: :model do
  let( :team_category ) { create( :team_category ) }

  it "has a valid factory" do
    expect( team_category ).to be_valid
  end

  it "is invalid without a category" do
    team_category.category = nil
    team_category.valid?
    expect( team_category.errors[:category] ).to include( "can't be blank" )
  end

  it "is invalid without a team" do
    team_category.team = nil
    team_category.valid?
    expect( team_category.errors[:team] ).to include( "can't be blank" )
  end

  it "is invalid without a unique team" do
    dup_team_category = build( :team_category, team: team_category.team, category: team_category.category )
    dup_team_category.valid?
    expect( dup_team_category.errors[:team] ).to include( "has already been taken" )
  end

  it "is invalid if the team has a different event from the category" do
    other_team = create( :event_team )
    team_category.team = other_team
    team_category.valid?
    expect( team_category.errors[:team] ).to include( "event does not match Category event" )
  end
end

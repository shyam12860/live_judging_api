# == Schema Information
#
# Table name: event_teams
#
#  id         :integer          not null, primary key
#  logo_id    :string
#  name       :string           not null
#  event_id   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe EventTeam, type: :model do
  let( :team ) { create( :event_team ) }

  it "has a valid factory" do
    expect( team ).to be_valid
  end

  it "is invalid without an event" do
    team.event = nil
    team.valid?
    expect( team.errors[:event] ).to include( "can't be blank" )
  end

  it "is invalid without a name" do
    team.name = nil
    team.valid?
    expect( team.errors[:name] ).to include( "can't be blank" )
  end

  it "is invalid without a unique name" do
    dup_team = build( :event_team, name: team.name, event: team.event )
    dup_team.valid?
    expect( dup_team.errors[:name] ).to include( "has already been taken" )
  end
end

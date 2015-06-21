# == Schema Information
#
# Table name: event_judges
#
#  id       :integer          not null, primary key
#  event_id :integer          not null
#  judge_id :integer          not null
#

require 'rails_helper'

RSpec.describe EventJudge do
  let( :event_judge ) { create( :event_judge ) }

  it "has a valid factory" do
    expect( event_judge ).to be_valid
  end

  it "is invalid without an event" do
    event_judge.event = nil
    event_judge.valid?
    expect( event_judge.errors[:event] ).to include( "can't be blank" )
  end

  it "is invalid without a judge" do
    event_judge.judge = nil
    event_judge.valid?
    expect( event_judge.errors[:judge] ).to include( "can't be blank" )
  end

  it "is invalid without a unique event-judge relationship" do
    duplicate = build( :event_judge, event: event_judge.event, judge: event_judge.judge )
    duplicate.valid?
    expect( duplicate.errors[:event] ).to include( "has already been taken" )
  end
end

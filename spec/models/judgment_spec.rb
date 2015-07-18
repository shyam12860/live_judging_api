# == Schema Information
#
# Table name: judgments
#
#  id               :integer          not null, primary key
#  value            :integer          not null
#  judge_id         :integer          not null
#  criterion_id     :integer          not null
#  team_category_id :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'rails_helper'

RSpec.describe Judgment, type: :model do
  let( :judgment ) { create( :judgment ) }

  it "has a valid factory" do
    expect( judgment ).to be_valid
  end

  it "is invalid without a value" do
    judgment.value = nil
    judgment.valid?
    expect( judgment.errors[:value] ).to include( "can't be blank" )
  end

  it "is invalid with a value less than the minimum value" do
    judgment.value = judgment.criterion.min_score - 1
    judgment.valid?
    expect( judgment.errors[:value] ).to include( "must be greater than or equal to #{judgment.criterion.min_score}" )
  end

  it "is invalid with a value greater than the maximum value" do
    judgment.value = judgment.criterion.max_score + 1
    judgment.valid?
    expect( judgment.errors[:value] ).to include( "must be less than or equal to #{judgment.criterion.max_score}" )
  end

  it "is valid with a value equal to the minimum value" do
    judgment.value = judgment.criterion.min_score
    judgment.valid?
    expect( judgment.errors[:value] ).to be_blank
    expect( judgment ).to be_valid
  end

  it "is valid with a value equal to the maximum value" do
    judgment.value = judgment.criterion.max_score
    judgment.valid?
    expect( judgment.errors[:value] ).to be_blank
    expect( judgment ).to be_valid
  end

  it "is invalid without a team category" do
    judgment.team_category = nil
    judgment.valid?
    expect( judgment.errors[:team_category] ).to include( "can't be blank" )
  end

  it "is invalid without a judge" do
    judgment.judge = nil
    judgment.valid?
    expect( judgment.errors[:judge] ).to include( "can't be blank" )
  end

  it "is invalid without a criterion" do
    judgment.criterion = nil
    judgment.valid?
    expect( judgment.errors[:criterion] ).to include( "can't be blank" )
  end

  it "is invalid without a unique judge, team_category, criterion combination" do
    dup_judgment = build( :judgment, judge: judgment.judge, team_category: judgment.team_category, criterion: judgment.criterion )
    dup_judgment.valid?
    expect( dup_judgment.errors[:criterion] ).to include( "has already been taken" )
  end

  it "is invalid when the judge event does not match the team event" do
    judgment.judge.event = create( :event )
    judgment.valid?
    expect( judgment.errors[:criterion] ).to include( "event does not match Team Category or Judge events" )
  end

  it "is invalid when the team event does not match the criterion event" do
    judgment.team_category.team.event = create( :event )
    judgment.valid?
    expect( judgment.errors[:criterion] ).to include( "event does not match Team Category or Judge events" )
  end

  it "is invalid when the judge event does not match the criterion event" do
    judgment.criterion.rubric.event = create( :event )
    judgment.valid?
    expect( judgment.errors[:criterion] ).to include( "event does not match Team Category or Judge events" )
  end
end

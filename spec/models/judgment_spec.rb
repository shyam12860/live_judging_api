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

  it "is invalid without a team" do
    judgment.team = nil
    judgment.valid?
    expect( judgment.errors[:team] ).to include( "can't be blank" )
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

  it "is invalid without a unique judge, team, criterion combination" do
    dup_judgment = build( :judgment, judge: judgment.judge, team: judgment.team, criterion: judgment.criterion )
    dup_judgment.valid?
    expect( dup_judgment.errors[:criterion] ).to include( "has already been taken" )
  end
end

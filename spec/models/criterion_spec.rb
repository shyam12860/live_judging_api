# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  label      :string           not null
#  min_score  :integer          default(0), not null
#  max_score  :integer          default(5), not null
#  rubric_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Criterion, type: :model do
  let( :criterion ) { create( :criterion ) }

  it "has a valid factory" do
    expect( criterion ).to be_valid
  end

  it "is invalid without a label" do
    criterion.label = nil
    criterion.valid?
    expect( criterion.errors[:label] ).to include( "can't be blank" )
  end

  it "is invalid without a unique label rubric combination" do
    dup_criterion = build( :criterion, label: criterion.label, rubric: criterion.rubric )
    dup_criterion.valid?
    expect( dup_criterion.errors[:label] ).to include( "has already been taken" )
  end

  it "is invalid without a minimum score" do
    criterion.min_score = nil
    criterion.valid?
    expect( criterion.errors[:min_score] ).to include( "can't be blank" )
  end

  it "is invalid with a minimum score less than 0" do
    criterion.min_score = -1
    criterion.valid?
    expect( criterion.errors[:min_score] ).to include( "must be greater than or equal to 0" )
  end

  it "is invalid with a minimum score equal to the maximum score" do
    criterion.min_score = criterion.max_score
    criterion.valid?
    expect( criterion.errors[:max_score] ).to include( "must be greater than #{criterion.min_score}" )
  end

  it "is invalid with a minimum score that is not an integer" do
    criterion.min_score = 0.001
    criterion.valid?
    expect( criterion.errors[:min_score] ).to include( "must be an integer" )
  end

  it "is invalid without a maximum score" do
    criterion.max_score = nil
    criterion.valid?
    expect( criterion.errors[:max_score] ).to include( "can't be blank" )
  end

  it "is invalid with a maximum score less than the minimum score" do
    criterion.max_score = criterion.min_score - 1
    criterion.valid?
    expect( criterion.errors[:max_score] ).to include( "must be greater than #{criterion.min_score}" )
  end

  it "is invalid with a maximum score that is not an integer" do
    criterion.max_score = 0.001
    criterion.valid?
    expect( criterion.errors[:max_score] ).to include( "must be an integer" )
  end

  it "is invalid without a rubric" do
    criterion.rubric = nil
    criterion.valid?
    expect( criterion.errors[:rubric] ).to include( "can't be blank" )
  end
end

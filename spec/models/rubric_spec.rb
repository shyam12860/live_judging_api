# == Schema Information
#
# Table name: rubrics
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  event_id   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Rubric, type: :model do
  let( :rubric ) { create( :rubric ) }

  it "has a valid factory" do
    expect( rubric ).to be_valid
  end

  it "is invalid without a name" do
    rubric.name = nil
    rubric.valid?
    expect( rubric.errors[:name] ).to include( "can't be blank" )
  end

  it "is invalid without an event" do
    rubric.event = nil
    rubric.valid?
    expect( rubric.errors[:event] ).to include( "can't be blank" )
  end

  it "is invalid without a unique name event combination" do
    dup_rubric = build( :rubric, name: rubric.name, event: rubric.event )
    dup_rubric.valid?
    expect( dup_rubric.errors[:name] ).to include( "has already been taken" )
  end
end

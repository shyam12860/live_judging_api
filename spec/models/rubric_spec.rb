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
end

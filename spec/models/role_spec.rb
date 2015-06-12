require 'rails_helper'

RSpec.describe Role, type: :model do
  let( :role ) { create( :role ) }

  it "has a valid factory" do
    expect( role ).to be_valid
  end

  it "is invalid without a label" do
    role.label = nil
    role.valid?
    expect( role.errors[:label] ).to include( "can't be blank" )
  end
end

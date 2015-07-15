# == Schema Information
#
# Table name: platforms
#
#  id    :integer          not null, primary key
#  label :string           not null
#

require 'rails_helper'

RSpec.describe Platform, type: :model do
  let( :platform ) { create( :platform ) }

  it "has a valid factory" do
    expect( platform ).to be_valid
  end

  it "is invalid without a label" do
    platform.label = nil
    platform.valid?
    expect( platform.errors[:label] ).to include( "can't be blank" )
  end

  it "is invalid without a unique label" do
    dup_platform = build( :platform, label: platform.label )
    dup_platform.valid?
    expect( dup_platform.errors[:label] ).to include( "has already been taken" )
  end
end

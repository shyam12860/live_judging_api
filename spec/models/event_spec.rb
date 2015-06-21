# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  location   :string           not null
#  start_time :datetime         not null
#  end_time   :datetime         not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Event, type: :model do
  let( :event ) { create( :event ) }

  it "has valid factories" do
    expect( event ).to be_valid
  end

  it "is invalid without a name" do
    event.name = nil
    event.valid?
    expect( event.errors[:name] ).to include( "can't be blank" )
  end

  it "is invalid without a location" do
    event.location = nil
    event.valid?
    expect( event.errors[:location] ).to include( "can't be blank" )
  end

  it "is invalid without a start time" do
    event.start_time = nil
    event.valid?
    expect( event.errors[:start_time] ).to include( "can't be blank" )
  end

  it "is invalid without an end time" do
    event.end_time = nil
    event.valid?
    expect( event.errors[:end_time] ).to include( "can't be blank" )
  end
end

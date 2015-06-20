require 'rails_helper'

RSpec.describe EventOrganizer, type: :model do
  let( :event_organizer ) { create( :event_organizer ) }

  it "has a valid factory" do
    expect( event_organizer ).to be_valid
  end

  it "is invalid without an event" do
    event_organizer.event = nil
    event_organizer.valid?
    expect( event_organizer.errors[:event] ).to include( "can't be blank" )
  end

  it "is invalid without an organizer" do
    event_organizer.organizer = nil
    event_organizer.valid?
    expect( event_organizer.errors[:organizer] ).to include( "can't be blank" )
  end
end

# == Schema Information
#
# Table name: event_categories
#
#  id          :integer          not null, primary key
#  event_id    :integer          not null
#  label       :string           not null
#  color       :integer          not null
#  due_at      :datetime
#  description :string
#  rubric_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe EventCategory, type: :model do
  let( :event_category ) { create( :event_category ) }

  it "has a valid factory" do
    expect( event_category ).to be_valid
  end

  it "is invalid witout an event" do
    event_category.event = nil
    event_category.valid?
    expect( event_category.errors[:event] ).to include( "can't be blank" )
  end

  it "is invalid without a label" do
    event_category.label = nil
    event_category.valid?
    expect( event_category.errors[:label] ).to include( "can't be blank" )
  end

  it "is invalid with a duplicated event and label" do
    dup_event_category = build( :event_category, label: event_category.label, event: event_category.event )
    dup_event_category.valid?
    expect( dup_event_category.errors[:label] ).to include( "has already been taken" )
  end

  it "is invalid without a color" do
    event_category.color = nil
    event_category.valid?
    expect( event_category.errors[:color] ).to include( "can't be blank" )
  end

  it "is invalid with a duplicated event and color" do
    dup_event_category = build( :event_category, color: event_category.color, event: event_category.event )
    dup_event_category.valid?
    expect( dup_event_category.errors[:color] ).to include( "has already been taken" )
  end
end

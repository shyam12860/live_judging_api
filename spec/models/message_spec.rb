# == Schema Information
#
# Table name: messages
#
#  id           :integer          not null, primary key
#  subject      :string           not null
#  body         :string           not null
#  sender_id    :integer          not null
#  recipient_id :integer          not null
#  read         :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe Message, type: :model do
  let( :message ) { create( :message ) }

  it "has a valid factory" do
    expect( message ).to be_valid
  end

  it "is invalid without a subject" do
    message.subject = nil
    message.valid?
    expect( message.errors[:subject] ).to include( "can't be blank" )
  end

  it "is invalid without a body" do
    message.body = nil
    message.valid?
    expect( message.errors[:body] ).to include( "can't be blank" )
  end

  it "is invalid without a sender" do
    message.sender = nil
    message.valid?
    expect( message.errors[:sender] ).to include( "can't be blank" )
  end

  it "is invalid without a recipient" do
    message.recipient = nil
    message.valid?
    expect( message.errors[:recipient] ).to include( "can't be blank" )
  end
end

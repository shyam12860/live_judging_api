# == Schema Information
#
# Table name: tokens
#
#  id           :integer          not null, primary key
#  access_token :string           not null
#  expires_at   :datetime         default(Fri, 31 Jul 2015 01:46:00 UTC +00:00), not null
#  user_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe Token do
  let( :token ) { create( :token ) }

  it "has valid factories" do
    expect( token ).to be_valid
  end

  it "is invalid without an access token" do
    token.access_token = nil
    token.valid?
    expect( token.errors[:access_token] ).to include( "can't be blank" )
  end

  it "is invalid without an expiration time" do
    token.expires_at = nil
    token.valid?
    expect( token.errors[:expires_at] ).to include( "can't be blank" )
  end

  it "is invalid without an associated user" do
    token.user = nil
    token.valid?
    expect( token.errors[:user] ).to include( "can't be blank" )
  end
end

require 'rails_helper'

RSpec.describe User do
  let( :user ) { create( :user ) }

  it "has valid factories" do
    expect( user ).to be_valid
  end

  it "is invalid without an email" do
    user.email = nil
    user.valid?
    expect( user.errors[:email] ).to include( "can't be blank" )
  end

  it "is invalid with badly formatted emails" do
  end

  it "is valid with well formatted emails" do
  end

  it "is invalid with a duplicated email" do
    dup_user = build( :user )
    dup_user.email = user.email
    dup_user.valid?
    expect( dup_user.errors[:email] ).to include( "has already been taken" )
  end

  it "is invalid without a password" do
    user.password = nil
    user.valid?
    expect( user.errors[:password_digest] ).to include( "can't be blank" )
    expect( user.errors[:password] ).to include( "can't be blank" )
  end

  it "is invalid with a password that is to short" do
    user.password = '12345'
    user.valid?
    expect( user.errors[:password] ).to include( "is too short (minimum is 6 characters)" )
  end

  it "is valid with a password of the minimum length" do
    user.password = '123456'
    user.valid?
    expect( user.errors[:password] ).to be_empty
  end

  it "is valid with a password of valid length" do
    user.password = '1234567'
    user.valid?
    expect( user.errors[:password] ).to be_empty
  end

  it "is invalid without a password confirmation" do
    user.password_confirmation = nil
    user.valid?
    expect( user.errors[:password_confirmation] ).to include( "can't be blank" )
  end

  it "is invalid without a first name" do
    user.first_name = nil
    user.valid?
    expect( user.errors[:first_name] ).to include( "can't be blank" )
  end

  it "is invalid without a last name" do
    user.last_name = nil
    user.valid?
    expect( user.errors[:last_name] ).to include( "can't be blank" )
  end

  it "retains its old token when updating" do
    old_token = user.token
    user.last_name = 'Test'
    user.save
    expect( user.token ).to eq( old_token )
  end

  it "generates a token after being created" do
    expect( user.token ).not_to be_blank
  end
end

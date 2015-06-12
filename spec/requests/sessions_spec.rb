require "rails_helper"

describe "Sessions API" do

  before { host! "api.example.com" }
  let( :user ) { create( :user ) }

  describe "GET /login" do
    describe "with valid credentials", :show_in_doc do
      before :each do
        base_64 = Base64.encode64( user.email + ":" + user.password )
        get "/login", nil, { "Authorization" => "Basic " + base_64 }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( serialize( UserSerializer, user ) )
      end
    end

    describe "with invalid credentials" do
      before :each do
        base_64 = Base64.encode64( "wrong_email@email.com:wrongpassword" )
        get "/login", nil, { "Authorization" => "Basic " + base_64 }
      end

      it "returns an unauthorized status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( "Bad credentials. Email/Password required." )
      end
    end
  end

  describe "GET /logout" do
    describe "with valid token", :show_in_doc do
      before :each do
        get "/logout", nil, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a no content status code" do
        expect( response ).to have_http_status( :no_content )
      end

      it "returns no content" do
        expect( response.body ).to be_empty
      end
    end

    describe "with invalid token" do
      before :each do
        get "/logout", nil, { "Authorization" => "Token token=" + SecureRandom.hex }
      end

      it "returns an unauthorized status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns no content" do
        expect( response.body ).to eq( "Bad credentials. Token required." )
      end
    end
  end
end

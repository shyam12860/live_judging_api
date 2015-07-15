require "rails_helper"

describe "messages API" do
  let( :user ) { create( :user ) }
  before { host! "api.example.com" }

  describe "GET /users/:user_id/messages" do
    let( :message ) { create( :message, sender: user ) }

    describe "with valid token", :show_in_doc do
      before :each do
        message.save
        get "/users/#{user.id}/messages", nil, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( serialize_array( MessageSerializer, [message], user ) )
      end
    end

    describe "with invalid token" do
      before :each do
        get "/users/#{user.id}/messages", nil, { "Authorization" => "Token token=" + SecureRandom.hex }
      end

      it "returns an unauthorized status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( "Bad credentials. Token required." )
      end
    end
  end

  describe "POST /messages" do
    describe "with valid attributes", :show_in_doc do
      before :each do
        post "/messages", attributes_for( :message, recipient_id: create( :user ).id ), { "Authorization" => "Token token=" + user.token.access_token } 
      end

      it "returns a created status code" do
        expect( response ).to have_http_status( :created )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( serialize( MessageSerializer, Message.last, user ) )
      end
    end

    describe "with invalid attributes" do
      before :each do
        post "/messages", attributes_for( :message, body: nil ), { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns an unprocessable entity status code" do
        expect( response ).to have_http_status( :unprocessable_entity )
      end

      it "returns the correct JSON" do
        expect( json_to_hash( response.body )[:body].first ).to eq( "can't be blank" )
      end
    end

    describe "with invalid token" do
      before :each do
        post "/messages", nil, { "Authorization" => "Token token=" + SecureRandom.hex }
      end

      it "returns an unauthorized status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( "Bad credentials. Token required." )
      end
    end
  end
end

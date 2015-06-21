require "rails_helper"

describe "Event Organizers API" do
  let( :user ) { create( :user ) }
  before { host! "api.example.com" }

  describe "GET /events/:event_id/organizers" do
    let( :event ) { create( :event ) }

    describe "with valid token", :show_in_doc do
      before :each do
        @organizers = [ user, create( :user ), create( :user ), create( :user )]
        event.organizers = @organizers
        event.save
        get "/events/#{event.id}/organizers", nil, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( json_at_key( response.body, "event_organizers" ) ).to eq( serialize_array( EventOrganizerSerializer, EventOrganizer.all, user ) )
      end
    end

    describe "with invalid token" do
      before :each do
        get "/events/#{event.id}/organizers", nil, { "Authorization" => "Token token=" + SecureRandom.hex }
      end

      it "returns an unauthorized status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( "Bad credentials. Token required." )
      end
    end
  end

  describe "POST /events/:event_id/organizers" do
    let( :event ) { create( :event, organizers: [user] ) }
    let( :organizer_user ) { create( :user ) }
    describe "with valid attributes", :show_in_doc do
      before :each do
        post "/events/#{event.id}/organizers", { user_id: organizer_user.id }, { "Authorization" => "Token token=" + user.token.access_token } 
      end

      it "returns a created status code" do
        expect( response ).to have_http_status( :created )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( serialize( EventOrganizerSerializer, EventOrganizer.last, user ) )
      end
    end

    describe "as a user that did not organize the event" do
      let( :other_user ) { create( :user ) }
      before :each do
        post "/events/#{event.id}/organizers", { user_id: organizer_user.id }, { "Authorization" => "Token token=" + other_user.token.access_token } 
      end

      it "returns a created status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns a blank response" do
        expect( response.body ).to be_blank
      end
    end

    describe "with invalid attributes" do
      before :each do
        post "/events/#{event.id}/organizers", { user_id: "asdoijf" }, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns an unprocessable entity status code" do
        expect( response ).to have_http_status( :unprocessable_entity )
      end

      it "returns the correct JSON" do
        expect( json_to_hash( response.body )[:organizer].first ).to eq( "can't be blank" )
      end
    end
  end

  describe "DELETE /events/:event_id/organizers/:id" do
    let( :organizer_user ) { create( :user ) }
    let( :event ) { create( :event, organizers: [user, organizer_user] ) }
    describe "with valid attributes", :show_in_doc do
      before :each do
        delete "/events/#{event.id}/organizers/#{organizer_user.id}", {}, { "Authorization" => "Token token=" + user.token.access_token } 
      end

      it "returns a created status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( response.body ).to be_blank
      end
    end

    describe "as a user that did not organize the event" do
      let( :other_user ) { create( :user ) }
      before :each do
        delete "/events/#{event.id}/organizers/#{organizer_user.id}", {}, { "Authorization" => "Token token=" + other_user.token.access_token } 
      end

      it "returns a created status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns a blank response" do
        expect( response.body ).to be_blank
      end
    end

    describe "with an invalid identifier" do
      before :each do
        delete "/events/#{event.id}/organizers/another_user", {}, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a not found entity status code" do
        expect( response ).to have_http_status( :not_found )
      end

      it "returns an empty response" do
        expect( response.body ).to be_blank
      end
    end
  end
end

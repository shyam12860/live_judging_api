require "rails_helper"

describe "Events API" do
  let( :user ) { create( :user ) }

  before { host! "api.example.com" }

  describe "GET /events" do
    let( :event ) { create( :event, organizers: [user], judges: [create( :user )], teams: [create( :event_team )] ) }

    describe "with valid token", :show_in_doc do
      before :each do
        @events = [create( :event, organizers: [user], judges: [create( :user )], teams: [create( :event_team )] ), event]
        @other_event = create( :event )
        get "/events", nil, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( serialize_array( EventSerializer, @events ) )
      end
    end

    describe "with invalid token" do
      before :each do
        get "/events", nil, { "Authorization" => "Token token=" + SecureRandom.hex }
      end

      it "returns an unauthorized status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( "Bad credentials. Token required." )
      end

    end
  end

  describe "GET /events/:id" do
    let( :event ) { create( :event, organizers: [user], judges: [create( :user )], teams: [create( :event_team )] ) }
  
    describe "with valid identifier", :show_in_doc do
      before :each do
        get "/events/#{event.id}", nil, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( serialize( EventSerializer, event, user ) )
      end
    end

    describe "with invalid identifier" do
      before :each do
        get "/events/baijwf1", nil, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a not found status code" do
        expect( response ).to have_http_status( :not_found )
      end

      it "returns the correct JSON" do
        expect( response.body ).to be_blank
      end
    end

    describe "with invalid token" do
      before :each do
        get "/events/#{event.id}", nil, { "Authorization" => "Token token=" + SecureRandom.hex }
      end

      it "returns an unauthorized status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( "Bad credentials. Token required." )
      end
    end
  end

  describe "PUT /events/:id" do
    let( :event ) { create( :event, organizers: [user], judges: [create( :user )], teams: [create( :event_team )] ) }
  
    describe "with valid identifier", :show_in_doc do
      before :each do
        put "/events/#{event.id}", { name: "Updated Name" }, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( serialize( EventSerializer, event.reload, user ) )
      end

      it "returns updated attributes" do
        expect( json_to_hash( response.body )[:name] ).to eq( "Updated Name" )
      end
    end

    describe "with invalid parameters" do
      before :each do
        put "/events/#{event.id}", { name: nil }, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns an unprocessable entity status code" do
        expect( response ).to have_http_status( :unprocessable_entity )
      end

      it "returns the correct JSON" do
        expect( json_to_hash( response.body )[:name].first ).to eq( "can't be blank" )
      end
    end

    describe "with invalid token" do
      before :each do
        put "/events/#{event.id}", { name: "Updated Name" }, { "Authorization" => "Token token=" + SecureRandom.hex }
      end

      it "returns an unauthorized status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( "Bad credentials. Token required." )
      end
    end

    describe "with an event that does not exist" do
      before :each do
        put "/events/aowiejf", { name: "Updated Name" }, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a not found status code" do
        expect( response ).to have_http_status( :not_found )
      end

      it "returns the correct JSON" do
        expect( response.body ).to be_blank
      end
    end
  end

  describe "POST /events" do
    describe "with valid attributes", :show_in_doc do
      before :each do
        post "/events", attributes_for( :event ), { "Authorization" => "Token token=" + user.token.access_token } 
      end

      it "returns a created status code" do
        expect( response ).to have_http_status( :created )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( serialize( EventSerializer, Event.first, user ) )
      end

      it "has the current user added as the event organizer" do
        expect( Event.first.organizers ).to match_array( [user] )
      end

      it "has an 'Uncategorized' category added to it" do
        expect( Event.first.categories.first.label ).to eq( "Uncategorized" )
      end
    end

    describe "with invalid attributes" do
      before :each do
        post "/events", attributes_for( :event, name: nil ), { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns an unprocessable entity status code" do
        expect( response ).to have_http_status( :unprocessable_entity )
      end

      it "returns the correct JSON" do
        expect( json_to_hash( response.body )[:name].first ).to eq( "can't be blank" )
      end
    end
  end
end

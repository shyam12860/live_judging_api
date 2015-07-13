require "rails_helper"

describe "Events API" do
  let( :user ) { create( :user ) }

  before { host! "api.example.com" }

  describe "GET /events" do
    let( :event ) { create( :event, organizers: [user] ) }
    describe "with valid token", :show_in_doc do
      before :each do
        @events = [create( :event, organizers: [user] ), event]
        user_2 = create( :user )
        post "/events", attributes_for( :event ), { "Authorization" => "Token token=" + user_2.token.access_token } 
        get "/events", nil, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( json_at_key( response.body, "events" ) ).to eq( serialize_array( EventSerializer, @events ) )
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
    let( :event ) { create( :event ) }
  
    describe "with valid identifier", :show_in_doc do
      before :each do
        get "/events/#{event.id}", nil, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( EventSerializer.new( event ).to_json )
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
    let( :event ) { create( :event ) }
  
    describe "with valid identifier", :show_in_doc do
      before :each do
        hash = attributes_for( :event, name: 'Updated Name' )
        put "/events/#{event.id}", hash, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( EventSerializer.new( event.reload ).to_json )
      end

      it "returns updated attributes" do
        expect( json_to_hash( response.body )[:event][:name] ).to eq( "Updated Name" )
      end
    end

    describe "with invalid parameters" do
      before :each do
        hash = attributes_for( :event, name: nil )
        put "/events/#{event.id}", hash, { "Authorization" => "Token token=" + user.token.access_token }
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
        hash = attributes_for( :event, name: 'Updated Name' )
        put "/events/#{event.id}", hash, { "Authorization" => "Token token=" + SecureRandom.hex }
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
        hash = attributes_for( :event, name: 'Updated Name' )
        put "/events/aowiejf", hash, { "Authorization" => "Token token=" + user.token.access_token }
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

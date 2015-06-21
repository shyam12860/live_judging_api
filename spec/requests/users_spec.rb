require "rails_helper"

describe "Users API" do

  before { host! "api.example.com" }

  describe "POST /users" do
    describe "with valid attributes", :show_in_doc do
      before :each do
        post "/users", attributes_for( :user ) 
      end

      it "returns a created status code" do
        expect( response ).to have_http_status( :created )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( serialize( UserSerializer, User.first ) )
      end
    end

    describe "with minimum valid attributes" do
      before :each do
        post "/users", attributes_for( :user ) 
      end

      it "returns a created status code" do
        expect( response ).to have_http_status( :created )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( serialize( UserSerializer, User.first ) )
      end
    end

    describe "with invalid attributes" do
      before :each do
        post "/users", attributes_for( :user, first_name: nil )
      end

      it "returns an unprocessable entity status code" do
        expect( response ).to have_http_status( :unprocessable_entity )
      end

      it "returns the correct JSON" do
        expect( json_to_hash( response.body )[:first_name].first ).to eq( "can't be blank" )
      end
    end
  end
  
  describe "PUT /users/:id" do
    let( :user ) { create( :user ) }
  
    describe "with valid identifier", :show_in_doc do
      before :each do
        hash = attributes_for( :user, first_name: 'Updated', last_name: 'Name' )
        put "/users/#{user.id}", hash, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( serialize( UserSerializer, user.reload ) )
      end

      it "returns updated attributes" do
        expect( json_to_hash( response.body )[:user][:name] ).to eq( "Updated Name" )
      end
    end

    describe "with invalid parameters" do
      before :each do
        hash = attributes_for( :user, first_name: nil )
        put "/users/#{user.id}", hash, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns an unprocessable entity status code" do
        expect( response ).to have_http_status( :unprocessable_entity )
      end

      it "returns the correct JSON" do
        expect( json_to_hash( response.body )[:first_name].first ).to eq( "can't be blank" )
      end
    end

    describe "with invalid token" do
      before :each do
        hash = attributes_for( :user, first_name: 'Updated', last_name: 'Name' )
        put "/users/#{user.id}", hash, { "Authorization" => "Token token=" + SecureRandom.hex }
      end

      it "returns an unauthorized status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( "Bad credentials. Token required." )
      end
    end

    describe "when the user does not exist" do
      before :each do
        hash = attributes_for( :user, first_name: 'Updated', last_name: 'Name' )
        put "/users/awoejfa", hash, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a not found status code" do
        expect( response ).to have_http_status( :not_found )
      end

      it "returns the correct JSON" do
        expect( response.body ).to be_blank
      end
    end
  end

  describe "GET /users" do
    let( :user ) { create( :user ) }
    describe "with valid token", :show_in_doc do
      before :each do
        @users = [create( :user ), user]
        get "/users", nil, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( json_at_key( response.body, "users" ) ).to eq( serialize_array( UserSerializer, @users, user ) )
      end
    end

    describe "with invalid token" do
      before :each do
        get "/users", nil, { "Authorization" => "Token token=" + SecureRandom.hex }
      end

      it "returns an unauthorized status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( "Bad credentials. Token required." )
      end

    end
  end

  describe "GET /users/:id" do
    let( :user ) { create( :user ) }
  
    describe "with valid identifier", :show_in_doc do
      before :each do
        get "/users/#{user.id}", nil, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( UserSerializer.new( user ).to_json )
      end
    end

    describe "with invalid identifier" do
      before :each do
        get "/users/baijwf1", nil, { "Authorization" => "Token token=" + user.token.access_token }
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
        get "/users/#{user.id}", nil, { "Authorization" => "Token token=" + SecureRandom.hex }
      end

      it "returns an unauthorized status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( "Bad credentials. Token required." )
      end
    end
  end

  describe "GET /users/:id/judged_events" do
    let( :user ) { create( :user ) }
    let( :judged_event ) { create( :event, judges: [user] ) }
    describe "with valid token", :show_in_doc do
      before :each do
        judged_event.save
        get "/users/#{user.id}/judged_events", nil, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( json_at_key( response.body, "event_judges" ) ).to eq( serialize_array( EventJudgeSerializer, [EventJudge.first], user ) )
      end
    end

    describe "with invalid token" do
      before :each do
        get "/users", nil, { "Authorization" => "Token token=" + SecureRandom.hex }
      end

      it "returns an unauthorized status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( "Bad credentials. Token required." )
      end
    end

    describe "with no judged events" do
      let( :other_user ) { create( :user ) }
      before :each do
        judged_event.save
        get "/users/#{other_user.id}/judged_events", nil, { "Authorization" => "Token token=" + other_user.token.access_token }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :ok )  
      end

      it "returns the correct JSON" do
        expect( json_to_hash( response.body )[:event_judges] ).to be_empty
      end
    end
  end

  describe "GET /users/:id/organized_events" do
    let( :user ) { create( :user ) }
    let( :organized_event ) { create( :event, organizers: [user] ) }

    describe "with valid token", :show_in_doc do
      before :each do
        organized_event.save
        get "/users/#{user.id}/organized_events", nil, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( json_at_key( response.body, "event_organizers" ) ).to eq( serialize_array( EventOrganizerSerializer, [EventOrganizer.first], user ) )
      end
    end

    describe "with invalid token" do
      before :each do
        get "/users", nil, { "Authorization" => "Token token=" + SecureRandom.hex }
      end

      it "returns an unauthorized status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( "Bad credentials. Token required." )
      end
    end

    describe "with no organized events" do
      let( :other_user ) { create( :user ) }

      before :each do
        organized_event.save
        get "/users/#{other_user.id}/organized_events", nil, { "Authorization" => "Token token=" + other_user.token.access_token }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :ok )  
      end

      it "returns the correct JSON" do
        expect( json_to_hash( response.body )[:event_organizers] ).to be_empty
      end
    end
  end
end

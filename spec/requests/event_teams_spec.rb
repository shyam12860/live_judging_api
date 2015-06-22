require "rails_helper"

describe "Event Teams API" do
  let( :user ) { create( :user ) }
  before { host! "api.example.com" }

  describe "GET /events/:event_id/teams" do
    let( :team_1 ) { create( :event_team ) }
    let( :team_2 ) { create( :event_team ) }
    let( :event ) { create( :event, teams: [ team_1, team_2 ] ) }

    describe "with valid token", :show_in_doc do
      before :each do
        get "/events/#{event.id}/teams", nil, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( json_at_key( response.body, "event_teams" ) ).to eq( serialize_array( EventTeamSerializer, EventTeam.where( event: event ), user ) )
      end
    end

    describe "with invalid token" do
      before :each do
        get "/events/#{event.id}/teams", nil, { "Authorization" => "Token token=" + SecureRandom.hex }
      end

      it "returns an unauthorized status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( "Bad credentials. Token required." )
      end
    end
  end

  describe "POST /events/:event_id/teams" do
    let( :team_1 ) { create( :event_team ) }
    let( :event ) { create( :event, teams: [team_1], organizers: [user] ) }
    describe "with valid attributes", :show_in_doc do
      before :each do
        post "/events/#{event.id}/teams", { name: "Test Team" }, { "Authorization" => "Token token=" + user.token.access_token } 
      end

      it "returns a created status code" do
        expect( response ).to have_http_status( :created )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( serialize( EventTeamSerializer, EventTeam.last, user ) )
      end
    end

    describe "as a user that did not organize the event" do
      let( :other_user ) { create( :user ) }
      before :each do
        post "/events/#{event.id}/teams", { name: "Test Team" }, { "Authorization" => "Token token=" + other_user.token.access_token } 
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
        post "/events/#{event.id}/teams", { name: nil }, { "Authorization" => "Token token=" + user.token.access_token }
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
        post "/events/#{event.id}/teams", nil, { "Authorization" => "Token token=" + SecureRandom.hex }
      end

      it "returns an unauthorized status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( "Bad credentials. Token required." )
      end
    end
  end

  describe "GET /teams/:id" do
    let( :user ) { create( :user ) }
    let( :team ) { create( :event_team ) }
    let( :event ) { create( :event, teams: [team], organizers: [user] ) }
  
    describe "with valid identifier", :show_in_doc do
      before :each do
        event.save
        get "/teams/#{team.id}", nil, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( serialize( EventTeamSerializer, team ) )
      end
    end

    describe "with invalid token" do
      before :each do
        event.save
        get "/teams/#{team.id}", nil, { "Authorization" => "Token token=" + SecureRandom.hex }
      end

      it "returns an unauthorized status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( "Bad credentials. Token required." )
      end
    end

    describe "when the category does not exist" do
      before :each do
        get "/teams/awoifa", nil, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a not found status code" do
        expect( response ).to have_http_status( :not_found )
      end

      it "returns the correct JSON" do
        expect( response.body ).to be_blank
      end
    end

    describe "as a user that did not organize the event" do
      let( :other_user ) { create( :user ) }
      before :each do
        event.save
        get "/teams/#{team.id}", nil, { "Authorization" => "Token token=" + other_user.token.access_token }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns the correct JSON" do
        expect( response.body ).to be_blank
      end
    end
  end

  describe "PUT /teams/:id" do
    let( :user ) { create( :user ) }
    let( :team ) { create( :event_team ) }
    let( :event ) { create( :event, teams: [team], organizers: [user] ) }
  
    describe "with valid identifier", :show_in_doc do
      before :each do
        put "/teams/#{team.id}", attributes_for( :event_team, name: "updated", event: event ), { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( serialize( EventTeamSerializer, team.reload ) )
      end

      it "returns updated attributes" do
        expect( json_to_hash( response.body )[:event_team][:name] ).to eq( "updated" )
      end
    end

    describe "with invalid parameters" do
      before :each do
        put "/teams/#{team.id}", attributes_for( :event_team, name: nil, event: event ), { "Authorization" => "Token token=" + user.token.access_token }
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
        put "/teams/#{team.id}", attributes_for( :event_team, name: "test", event: event ), { "Authorization" => "Token token=" + SecureRandom.hex }
      end

      it "returns an unauthorized status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( "Bad credentials. Token required." )
      end
    end

    describe "when the team does not exist" do
      before :each do
        put "/teams/awoifa", attributes_for( :event_team, name: "test", event: event ), { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a not found status code" do
        expect( response ).to have_http_status( :not_found )
      end

      it "returns the correct JSON" do
        expect( response.body ).to be_blank
      end
    end
  end

  describe "DELETE /teams/:id" do
    let( :team ) { create( :event_team ) }
    let( :event ) { create( :event, teams: [team], organizers: [user] ) }
    describe "with valid attributes", :show_in_doc do
      before :each do
        event.save
        delete "/teams/#{team.id}", {}, { "Authorization" => "Token token=" + user.token.access_token } 
      end

      it "returns an ok status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( response.body ).to be_blank
      end
    end

    describe "as a user that did not organize the event" do
      let( :other_user ) { create( :user ) }
      before :each do
        event.save
        delete "/teams/#{team.id}", {}, { "Authorization" => "Token token=" + other_user.token.access_token } 
      end

      it "returns a created status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns a blank response" do
        expect( response.body ).to be_blank
      end
    end

    describe "with invalid token" do
      before :each do
        event.save
        delete "/teams/#{team.id}", nil, { "Authorization" => "Token token=" + SecureRandom.hex }
      end

      it "returns an unauthorized status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( "Bad credentials. Token required." )
      end
    end

    describe "when the team does not exist" do
      before :each do
        event.save
        delete "/teams/aowijfoawe", {}, { "Authorization" => "Token token=" + user.token.access_token } 
      end

      it "returns a not found status code" do
        expect( response ).to have_http_status( :not_found )
      end

      it "returns a blank response" do
        expect( response.body ).to be_blank
      end
    end
  end
end

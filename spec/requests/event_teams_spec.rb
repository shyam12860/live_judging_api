require "rails_helper"

describe "Event Teams API" do
  let( :user ) { create( :user ) }
  before { host! "api.example.com" }

  describe "GET /events/:event_id/teams" do
    let( :event ) { create( :event, teams: [create( :event_team ), create( :event_team )], judges: [create( :user ), create( :user )], organizers: [user] ) }

    describe "with valid token", :show_in_doc do
      before :each do
        event.categories << create( :event_category, rubric_categories: [create( :rubric_category, rubric: create( :rubric, event: event ) )] )
        get "/events/#{event.id}/teams", nil, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( serialize_array( EventTeamSerializer, EventTeam.where( event: event ), user ) )
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
    let( :event ) { create( :event, teams: [create( :event_team ), create( :event_team )], judges: [create( :user ), create( :user )], organizers: [user] ) }
    describe "with valid attributes", :show_in_doc do
      before :each do
        event.categories << create( :event_category, rubric_categories: [create( :rubric_category, rubric: create( :rubric, event: event ) )] )
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
    let( :team ) { create( :event_team ) }
    let( :event ) { create( :event, teams: [team, create( :event_team )], judges: [create( :user ), create( :user )], organizers: [user] ) }
  
    describe "with valid identifier", :show_in_doc do
      before :each do
        event.categories << create( :event_category, rubric_categories: [create( :rubric_category, rubric: create( :rubric, event: event ) )] )
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
    let( :team ) { create( :event_team ) }
    let( :event ) { create( :event, teams: [team, create( :event_team )], judges: [create( :user ), create( :user )], organizers: [user] ) }
  
    describe "with valid identifier", :show_in_doc do
      before :each do
        event.categories << create( :event_category, rubric_categories: [create( :rubric_category, rubric: create( :rubric, event: event ) )] )
        put "/teams/#{team.id}", attributes_for( :event_team, name: "updated", event: event ), { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( serialize( EventTeamSerializer, team.reload ) )
      end

      it "returns updated attributes" do
        expect( json_to_hash( response.body )[:name] ).to eq( "updated" )
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
    let( :event ) { create( :event, teams: [team, create( :event_team )], judges: [create( :user ), create( :user )], organizers: [user] ) }
    describe "with valid attributes", :show_in_doc do
      before :each do
        event.categories << create( :event_category, rubric_categories: [create( :rubric_category, rubric: create( :rubric, event: event ) )] )
        delete "/teams/#{team.id}", {}, { "Authorization" => "Token token=" + user.token.access_token } 
      end

      it "returns an ok status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( response.body ).to be_blank
      end
    end

    describe "with a judge attached to the team" do
      let( :judge_team ) { create( :judge_team, team: team ) }
      let( :team_category ) { create( :team_category, team: team ) }

      before :each do
        event.save
        judge_team.save
        team_category.save
        delete "/teams/#{team.id}", {}, { "Authorization" => "Token token=" + user.token.access_token } 
      end

      it "removes all judges from the team" do
        expect( JudgeTeam.where( team_id: team.id ) ).to be_empty
      end

      it "removes all categories from the team" do
        expect( TeamCategory.where( team_id: team.id ) ).to be_empty
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

require "rails_helper"

describe "Judge Teams API" do
  let( :user ) { create( :user ) }
  before { host! "api.example.com" }

  describe "GET /judges/:judge_id/teams" do
    let( :judge_team ) { create( :judge_team ) }

    describe "with valid token", :show_in_doc do
      before :each do
        get "/judges/#{judge_team.judge.id}/teams", nil, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( json_at_key( response.body, "judge_teams" ) ).to eq( serialize_array( JudgeTeamSerializer, JudgeTeam.where( team: judge_team.team ), user ) )
      end
    end

    describe "with invalid token" do
      before :each do
        get "/judges/#{judge_team.judge.id}/teams", nil, { "Authorization" => "Token token=" + SecureRandom.hex }
      end

      it "returns an unauthorized status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( "Bad credentials. Token required." )
      end
    end
  end

  describe "DELETE /judges/:judge_id/teams/:id" do
    let( :judge_team ) { create( :judge_team ) }

    describe "with valid attributes", :show_in_doc do
      before :each do
        judge_team.judge.event.organizers << user
        judge_team.save
        delete "/judges/#{judge_team.judge.id}/teams/#{judge_team.team.id}", {}, { "Authorization" => "Token token=" + user.token.access_token } 
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
        delete "/judges/#{judge_team.judge.id}/teams/#{judge_team.team.id}", {}, { "Authorization" => "Token token=" + other_user.token.access_token } 
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
        delete "/judges/#{judge_team.judge.id}/teams/#{judge_team.team.id}", nil, { "Authorization" => "Token token=" + SecureRandom.hex }
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
        delete "/judges/#{judge_team.judge.id}/teams/aowijfea", {}, { "Authorization" => "Token token=" + user.token.access_token } 
      end

      it "returns a not found status code" do
        expect( response ).to have_http_status( :not_found )
      end

      it "returns a blank response" do
        expect( response.body ).to be_blank
      end
    end
  end

  describe "POST /judges/:judge_id/teams" do
    let( :judge ) { create( :event_judge ) }
    let( :team ) { create( :event_team, event: judge.event ) }

    describe "with valid attributes", :show_in_doc do
      before :each do
        judge.event.organizers << user
        judge.save
        team.save
        post "/judges/#{judge.id}/teams", { team_id: team.id }, { "Authorization" => "Token token=" + user.token.access_token } 
      end

      it "returns a created status code" do
        expect( response ).to have_http_status( :created )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( serialize( JudgeTeamSerializer, JudgeTeam.last, user ) )
      end
    end

    describe "as a user that did not organize the event" do
      let( :other_user ) { create( :user ) }
      before :each do
        post "/judges/#{judge.id}/teams", { team_id: team.id }, { "Authorization" => "Token token=" + other_user.token.access_token } 
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
        judge.event.organizers << user
        judge.save
        post "/judges/#{judge.id}/teams", { team_id: nil }, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns an unprocessable entity status code" do
        expect( response ).to have_http_status( :unprocessable_entity )
      end

      it "returns the correct JSON" do
        expect( json_to_hash( response.body )[:team].first ).to eq( "can't be blank" )
      end
    end

    describe "with invalid token" do
      before :each do
        post "/judges/#{judge.id}/teams", nil, { "Authorization" => "Token token=" + SecureRandom.hex }
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

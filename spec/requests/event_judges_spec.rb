require "rails_helper"

describe "Event Judges API" do
  let( :user ) { create( :user ) }

  before { host! "api.example.com" }

  describe "GET /events/:event_id/judges" do
    let( :event ) { create( :event, organizers: [user] ) }

    describe "with valid token", :show_in_doc do
      before :each do
        @judges = [ create( :user ), create( :user ), create( :user )]
        event.judges = @judges
        event.save
        get "/events/#{event.id}/judges", nil, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( json_at_key( response.body, "event_judges" ) ).to eq( serialize_array( EventJudgeSerializer, EventJudge.all, user ) )
      end
    end

    describe "with invalid token" do
      before :each do
        get "/events/#{event.id}/judges", nil, { "Authorization" => "Token token=" + SecureRandom.hex }
      end

      it "returns an unauthorized status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( "Bad credentials. Token required." )
      end
    end
  end

  describe "POST /events/:event_id/judges" do
    let( :event ) { create( :event, organizers: [user] ) }
    let( :judge_user ) { create( :user ) }
    describe "with valid attributes", :show_in_doc do
      before :each do
        post "/events/#{event.id}/judges", { judge_id: judge_user.id }, { "Authorization" => "Token token=" + user.token.access_token } 
      end

      it "returns a created status code" do
        expect( response ).to have_http_status( :created )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( serialize( EventJudgeSerializer, EventJudge.first, user ) )
      end
    end

    describe "as a user that did not organize the event" do
      let( :other_user ) { create( :user ) }
      before :each do
        post "/events/#{event.id}/judges", { judge_id: judge_user.id }, { "Authorization" => "Token token=" + other_user.token.access_token } 
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
        post "/events/#{event.id}/judges", { judge_id: "asdoijf" }, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns an unprocessable entity status code" do
        expect( response ).to have_http_status( :unprocessable_entity )
      end

      it "returns the correct JSON" do
        expect( json_to_hash( response.body )[:judge].first ).to eq( "can't be blank" )
      end
    end
  end

  describe "DELETE /judges/:id" do
    let( :event ) { create( :event, organizers: [user] ) }
    let( :event_judge ) { create( :event_judge, event: event ) }
    describe "with valid attributes", :show_in_doc do
      before :each do
        delete "/judges/#{event_judge.id}", {}, { "Authorization" => "Token token=" + user.token.access_token } 
      end

      it "returns an ok status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( response.body ).to be_blank
      end
    end

    describe "when the judge is judging a team" do
      let( :judge_team ) { create( :judge_team, judge: event_judge ) }

      before :each do
        judge_team.save
        delete "/judges/#{event_judge.id}", {}, { "Authorization" => "Token token=" + user.token.access_token } 
      end

      it "removes the judge from any teams they were judging" do
        expect( JudgeTeam.where( judge_id: event_judge.id ) ).to be_empty
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
        delete "/judges/#{event_judge.id}", {}, { "Authorization" => "Token token=" + other_user.token.access_token } 
      end

      it "returns a created status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns a blank response" do
        expect( response.body ).to be_blank
      end
    end

    describe "with invalid judge identifier" do
      before :each do
        delete "/judges/another_user", {}, { "Authorization" => "Token token=" + user.token.access_token }
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

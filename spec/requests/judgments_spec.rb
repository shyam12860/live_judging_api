require "rails_helper"

describe "Judgments API" do
  let( :user ) { create( :user ) }
  before { host! "api.example.com" }

  describe "GET /rubrics/:rubric_id/judgments" do
    let( :event ) { create( :event ) }
    let( :judgment_1 ) { 
      create( :judgment,
        team: create( :event_team, event: event ), 
        judge: create( :event_judge, event: event ),
        criterion: create( :criterion, rubric: create( :rubric, event: event ) )
      )
    }
    let( :judgment_2 ) { 
      create( :judgment,
        team: create( :event_team, event: event ), 
        judge: create( :event_judge, event: event ),
        criterion: create( :criterion, rubric: create( :rubric, event: event ) )
      )
    }

    describe "with valid token", :show_in_doc do
      before :each do
        get "/events/#{event.id}/judgments", nil, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( json_at_key( response.body, "judgments" ) ).to eq( serialize_array( JudgmentSerializer, Judgment.all, user ) )
      end
    end

    describe "with invalid token" do
      before :each do
        get "/events/#{event.id}/judgments", nil, { "Authorization" => "Token token=" + SecureRandom.hex }
      end

      it "returns an unauthorized status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( "Bad credentials. Token required." )
      end
    end
  end

  describe "GET /judgments/:id" do
    let( :event ) { create( :event ) }
    let( :judgment ) { 
      create( :judgment,
        team: create( :event_team, event: event ), 
        judge: create( :event_judge, event: event ),
        criterion: create( :criterion, rubric: create( :rubric, event: event ) )
      )
    }

    describe "with valid token", :show_in_doc do
      before :each do
        event.judges << user
        get "/judgments/#{judgment.id}", nil, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( serialize( JudgmentSerializer, judgment, user ) )
      end
    end

    describe "with invalid token" do
      before :each do
        event.judges << user
        get "/judgments/#{judgment.id}", nil, { "Authorization" => "Token token=" + SecureRandom.hex }
      end

      it "returns an unauthorized status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( "Bad credentials. Token required." )
      end
    end

    describe "when the judgment does not exist" do
      before :each do
        event.judges << user
        get "/judgments/aowjef", nil, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a not found status code" do
        expect( response ).to have_http_status( :not_found )
      end

      it "returns the correct JSON" do
        expect( response.body ).to be_blank
      end
    end
  end
  
  describe "POST /judgments" do
    let( :event ) { create( :event ) }
    let( :judge ) { create( :event_judge, event: event ) }
    let( :team ) { create( :event_team, event: event ) }
    let( :rubric ) { create( :rubric, event: event ) }
    let( :criterion ) { create( :criterion, rubric: rubric ) }

    describe "with valid attributes", :show_in_doc do
      before :each do
        event.judges << user
        post "/judgments", { judge_id: judge.id, team_id: team.id, criterion_id: criterion.id, value: criterion.max_score }, { "Authorization" => "Token token=" + user.token.access_token } 
      end

      it "returns a created status code" do
        expect( response ).to have_http_status( :created )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( serialize( JudgmentSerializer, Judgment.last, user ) )
      end
    end

    describe "as a user that did not organize the event" do
      let( :other_user ) { create( :user ) }
      before :each do
        event.judges << user
        post "/judgments", { judge_id: judge.id, team_id: team.id, criterion_id: criterion.id, value: criterion.max_score }, { "Authorization" => "Token token=" + other_user.token.access_token } 
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
        event.judges << user
        post "/judgments", { judge_id: judge.id, team_id: team.id, criterion_id: criterion.id, value: nil }, { "Authorization" => "Token token=" + user.token.access_token } 
      end

      it "returns an unprocessable entity status code" do
        expect( response ).to have_http_status( :unprocessable_entity )
      end

      it "returns the correct JSON" do
        expect( json_to_hash( response.body )[:value].first ).to eq( "can't be blank" )
      end
    end

    describe "with invalid token" do
      before :each do
        event.judges << user
        post "/judgments", { judge_id: judge.id, team_id: team.id, criterion_id: criterion.id, value: criterion.max_score }, { "Authorization" => "Token token=" + SecureRandom.hex } 
      end

      it "returns an unauthorized status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( "Bad credentials. Token required." )
      end
    end
  end

  describe "PUT /judgments/:id" do
    let( :event ) { create( :event ) }
    let( :judgment ) { create( :judgment, judge: create( :event_judge, event: event ), team: create( :event_team, event: event ), criterion: create( :criterion, rubric: create( :rubric, event: event ) ) ) }
  
    describe "with valid identifier", :show_in_doc do
      before :each do
        event.judges << user
        put "/judgments/#{judgment.id}", { value: judgment.value + 1 }, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( JudgmentSerializer.new( judgment.reload ).to_json )
      end

      it "returns updated attributes" do
        expect( json_to_hash( response.body )[:judgment][:value] ).to eq( judgment.value + 1 )
      end
    end

    describe "with invalid parameters" do
      before :each do
        event.judges << user
        put "/judgments/#{judgment.id}", { value: nil }, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns an unprocessable entity status code" do
        expect( response ).to have_http_status( :unprocessable_entity )
      end

      it "returns the correct JSON" do
        expect( json_to_hash( response.body )[:value].first ).to eq( "can't be blank" )
      end
    end

    describe "with invalid token" do
      before :each do
        event.judges << user
        put "/judgments/#{judgment.id}", { value: judgment.value + 1 }, { "Authorization" => "Token token=" + SecureRandom.hex }
      end

      it "returns an unauthorized status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( "Bad credentials. Token required." )
      end
    end

    describe "when the judgment does not exist" do
      before :each do
        event.judges << user
        put "/judgments/asodijfawoe", { value: judgment.value + 1 }, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a not found status code" do
        expect( response ).to have_http_status( :not_found )
      end

      it "returns the correct JSON" do
        expect( response.body ).to be_blank
      end
    end
  end
end

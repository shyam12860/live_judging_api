require "rails_helper"

describe "Criteria API" do
  let( :user ) { create( :user ) }
  before { host! "api.example.com" }

  describe "GET /criteria/:id" do
    let( :criterion ) { create( :criterion ) }

    describe "with valid token", :show_in_doc do
      before :each do
        get "/criteria/#{criterion.id}", nil, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( serialize( CriterionSerializer, criterion, user ) )
      end
    end

    describe "with invalid token" do
      before :each do
        get "/criteria/#{criterion.id}", nil, { "Authorization" => "Token token=" + SecureRandom.hex }
      end

      it "returns an unauthorized status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( "Bad credentials. Token required." )
      end
    end

    describe "when the criterion does not exist" do
      before :each do
        get "/criteria/aowjef", nil, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a not found status code" do
        expect( response ).to have_http_status( :not_found )
      end

      it "returns the correct JSON" do
        expect( response.body ).to be_blank
      end
    end
  end

  describe "GET /rubrics/:rubric_id/criteria" do
    let( :criterion ) { create( :criterion ) }

    describe "with valid token", :show_in_doc do
      before :each do
        get "/rubrics/#{criterion.rubric.id}/criteria", nil, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( json_at_key( response.body, "criteria" ) ).to eq( serialize_array( CriterionSerializer, Criterion.where( id: criterion ), user ) )
      end
    end

    describe "with invalid token" do
      before :each do
        get "/rubrics/#{criterion.rubric.id}/criteria", nil, { "Authorization" => "Token token=" + SecureRandom.hex }
      end

      it "returns an unauthorized status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( "Bad credentials. Token required." )
      end
    end
  end

  describe "DELETE /criteria/:id" do
    let( :rubric ) { create( :rubric ) }
    let( :criterion ) { create( :criterion, rubric: rubric ) }

    describe "with valid attributes", :show_in_doc do
      before :each do
        rubric.event.organizers << user
        rubric.save
        delete "/criteria/#{criterion.id}", {}, { "Authorization" => "Token token=" + user.token.access_token } 
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
        delete "/criteria/#{criterion.id}", {}, { "Authorization" => "Token token=" + other_user.token.access_token } 
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
        delete "/criteria/#{criterion.id}", nil, { "Authorization" => "Token token=" + SecureRandom.hex }
      end

      it "returns an unauthorized status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( "Bad credentials. Token required." )
      end
    end

    describe "when the criterion does not exist" do
      before :each do
        delete "/criteria/aowijfea", {}, { "Authorization" => "Token token=" + user.token.access_token } 
      end

      it "returns a not found status code" do
        expect( response ).to have_http_status( :not_found )
      end

      it "returns a blank response" do
        expect( response.body ).to be_blank
      end
    end
  end

  describe "POST /rubrics/:rubric_id/criteria" do
    let( :rubric ) { create( :rubric ) }

    describe "with valid attributes", :show_in_doc do
      before :each do
        rubric.event.organizers << user
        rubric.save
        post "/rubrics/#{rubric.id}/criteria", attributes_for( :criterion, rubric: rubric ), { "Authorization" => "Token token=" + user.token.access_token } 
      end

      it "returns a created status code" do
        expect( response ).to have_http_status( :created )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( serialize( CriterionSerializer, Criterion.last, user ) )
      end
    end

    describe "as a user that did not organize the event" do
      let( :other_user ) { create( :user ) }
      before :each do
        rubric.event.organizers << user
        rubric.save
        post "/rubrics/#{rubric.id}/criteria", attributes_for( :criterion, rubric: rubric ), { "Authorization" => "Token token=" + other_user.token.access_token } 
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
        rubric.event.organizers << user
        rubric.save
        post "/rubrics/#{rubric.id}/criteria", attributes_for( :criterion, label: nil, rubric: rubric ), { "Authorization" => "Token token=" + user.token.access_token } 
      end

      it "returns an unprocessable entity status code" do
        expect( response ).to have_http_status( :unprocessable_entity )
      end

      it "returns the correct JSON" do
        expect( json_to_hash( response.body )[:label].first ).to eq( "can't be blank" )
      end
    end

    describe "with invalid token" do
      before :each do
        rubric.event.organizers << user
        rubric.save
        post "/rubrics/#{rubric.id}/criteria", attributes_for( :criterion, rubric: rubric ), { "Authorization" => "Token token=" + SecureRandom.hex } 
      end

      it "returns an unauthorized status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( "Bad credentials. Token required." )
      end
    end
  end

  describe "PUT /criteria/:id" do
    let( :criterion ) { create( :criterion ) }
  
    describe "with valid identifier", :show_in_doc do
      before :each do
        criterion.rubric.event.organizers << user
        criterion.rubric.event.save
        hash = attributes_for( :criterion, min_score: criterion.min_score + 1 )
        put "/criteria/#{criterion.id}", hash, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( CriterionSerializer.new( criterion.reload ).to_json )
      end

      it "returns updated attributes" do
        expect( json_to_hash( response.body )[:criterion][:min_score] ).to eq( criterion.min_score + 1 )
      end
    end

    describe "with invalid parameters" do
      before :each do
        criterion.rubric.event.organizers << user
        criterion.rubric.event.save
        hash = attributes_for( :criterion, min_score: nil )
        put "/criteria/#{criterion.id}", hash, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns an unprocessable entity status code" do
        expect( response ).to have_http_status( :unprocessable_entity )
      end

      it "returns the correct JSON" do
        expect( json_to_hash( response.body )[:min_score].first ).to eq( "can't be blank" )
      end
    end

    describe "with invalid token" do
      before :each do
        criterion.rubric.event.organizers << user
        criterion.rubric.event.save
        hash = attributes_for( :criterion, min_score: criterion.min_score + 1 )
        put "/criteria/#{criterion.id}", hash, { "Authorization" => "Token token=" + SecureRandom.hex }
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

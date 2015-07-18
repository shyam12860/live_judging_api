require "rails_helper"

describe "Rubrics API" do
  let( :user ) { create( :user ) }
  before { host! "api.example.com" }

  describe "GET /events/:event_id/rubrics" do
    let( :event ) { create( :event, organizers: [user] ) }

    before :each do
        event.categories << create( :event_category, rubric: create( :rubric, event: event ) )
    end

    describe "with valid token", :show_in_doc do
      before :each do
        get "/events/#{event.id}/rubrics", nil, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( serialize_array( RubricSerializer, Rubric.where( event: event ), user ) )
      end
    end

    describe "with invalid token" do
      before :each do
        get "/events/#{event.id}/rubrics", nil, { "Authorization" => "Token token=" + SecureRandom.hex }
      end

      it "returns an unauthorized status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( "Bad credentials. Token required." )
      end
    end
  end

  describe "POST /events/:event_id/rubrics" do
    let( :event ) { create( :event, organizers: [user] ) }

    before :each do
        event.categories << create( :event_category, rubric: create( :rubric, event: event ) )
    end
    
    describe "with valid attributes", :show_in_doc do
      before :each do
        post "/events/#{event.id}/rubrics", { name: "Test rubric" }, { "Authorization" => "Token token=" + user.token.access_token } 
      end

      it "returns a created status code" do
        expect( response ).to have_http_status( :created )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( serialize( RubricSerializer, Rubric.last, user ) )
      end
    end

    describe "as a user that did not organize the event" do
      let( :other_user ) { create( :user ) }
      before :each do
        post "/events/#{event.id}/rubrics", { name: "Test rubric" }, { "Authorization" => "Token token=" + other_user.token.access_token } 
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
        post "/events/#{event.id}/rubrics", { name: nil }, { "Authorization" => "Token token=" + user.token.access_token }
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
        post "/events/#{event.id}/rubrics", nil, { "Authorization" => "Token token=" + SecureRandom.hex }
      end

      it "returns an unauthorized status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( "Bad credentials. Token required." )
      end
    end
  end

  describe "GET /rubrics/:id" do
    let( :user ) { create( :user ) }
    let( :event ) { create( :event, organizers: [user] ) }
    let( :rubric ) { create( :rubric, event: event, criteria: [create( :criterion )] ) }

    before :each do
        event.categories << create( :event_category, rubric: rubric )
    end
  
    describe "with valid identifier", :show_in_doc do
      before :each do
        get "/rubrics/#{rubric.id}", nil, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( serialize( RubricSerializer, rubric.reload, user ) )
      end
    end

    describe "with invalid token" do
      before :each do
        get "/rubrics/#{rubric.id}", nil, { "Authorization" => "Token token=" + SecureRandom.hex }
      end

      it "returns an unauthorized status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( "Bad credentials. Token required." )
      end
    end

    describe "when the rubric does not exist" do
      before :each do
        get "/rubrics/awoifa", nil, { "Authorization" => "Token token=" + user.token.access_token }
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
        get "/rubrics/#{rubric.id}", nil, { "Authorization" => "Token token=" + other_user.token.access_token }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns the correct JSON" do
        expect( response.body ).to be_blank
      end
    end
  end

  describe "PUT /rubrics/:id" do
    let( :user ) { create( :user ) }
    let( :event ) { create( :event, organizers: [user] ) }
    let( :rubric ) { create( :rubric, event: event ) }

    before :each do
        event.categories << create( :event_category, rubric: rubric )
    end
  
    describe "with valid identifier", :show_in_doc do
      before :each do
        put "/rubrics/#{rubric.id}", { name: "updated" }, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( serialize( RubricSerializer, rubric.reload ) )
      end

      it "returns updated attributes" do
        expect( json_to_hash( response.body )[:name] ).to eq( "updated" )
      end
    end

    describe "with invalid parameters" do
      before :each do
        put "/rubrics/#{rubric.id}", { name: nil, event: event }, { "Authorization" => "Token token=" + user.token.access_token }
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
        put "/rubrics/#{rubric.id}", { name: "test" }, { "Authorization" => "Token token=" + SecureRandom.hex }
      end

      it "returns an unauthorized status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( "Bad credentials. Token required." )
      end
    end

    describe "when the rubric does not exist" do
      before :each do
        put "/rubrics/awoifa", { name: "test" }, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a not found status code" do
        expect( response ).to have_http_status( :not_found )
      end

      it "returns the correct JSON" do
        expect( response.body ).to be_blank
      end
    end
  end

  describe "DELETE /rubrics/:id" do
    let( :event ) { create( :event, organizers: [user] ) }
    let( :rubric ) { create( :rubric, event: event ) }

    before :each do
        event.categories << create( :event_category, rubric: rubric )
    end

    describe "with valid attributes", :show_in_doc do
      before :each do
        delete "/rubrics/#{rubric.id}", {}, { "Authorization" => "Token token=" + user.token.access_token } 
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
        delete "/rubrics/#{rubric.id}", {}, { "Authorization" => "Token token=" + other_user.token.access_token } 
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
        delete "/rubrics/#{rubric.id}", nil, { "Authorization" => "Token token=" + SecureRandom.hex }
      end

      it "returns an unauthorized status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( "Bad credentials. Token required." )
      end
    end

    describe "when the rubric does not exist" do
      before :each do
        delete "/rubrics/aowijfoawe", {}, { "Authorization" => "Token token=" + user.token.access_token } 
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

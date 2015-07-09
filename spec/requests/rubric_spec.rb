require "rails_helper"

describe "Rubrics API" do
  let( :user ) { create( :user ) }
  before { host! "api.example.com" }

  describe "GET /events/:event_id/rubrics" do
    let( :rubric_1 ) { create( :rubric ) }
    let( :rubric_2 ) { create( :rubric ) }
    let( :event ) { create( :event, rubrics: [ rubric_1, rubric_2 ] ) }

    describe "with valid token", :show_in_doc do
      before :each do
        get "/events/#{event.id}/rubrics", nil, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( json_at_key( response.body, "rubrics" ) ).to eq( serialize_array( RubricSerializer, Rubric.where( event: event ), user ) )
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
    let( :rubric_1 ) { create( :rubric ) }
    let( :event ) { create( :event, rubrics: [rubric_1], organizers: [user] ) }
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
    let( :rubric ) { create( :rubric ) }
    let( :event ) { create( :event, rubrics: [rubric], organizers: [user] ) }
  
    describe "with valid identifier", :show_in_doc do
      before :each do
        event.save
        get "/rubrics/#{rubric.id}", nil, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( serialize( RubricSerializer, rubric ) )
      end
    end

    describe "with invalid token" do
      before :each do
        event.save
        get "/rubrics/#{rubric.id}", nil, { "Authorization" => "Token token=" + SecureRandom.hex }
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
        event.save
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
    let( :rubric ) { create( :rubric ) }
    let( :event ) { create( :event, rubrics: [rubric], organizers: [user] ) }
  
    describe "with valid identifier", :show_in_doc do
      before :each do
        put "/rubrics/#{rubric.id}", attributes_for( :rubric, name: "updated", event: event ), { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( serialize( RubricSerializer, rubric.reload ) )
      end

      it "returns updated attributes" do
        expect( json_to_hash( response.body )[:rubric][:name] ).to eq( "updated" )
      end
    end

    describe "with invalid parameters" do
      before :each do
        put "/rubrics/#{rubric.id}", attributes_for( :rubric, name: nil, event: event ), { "Authorization" => "Token token=" + user.token.access_token }
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
        put "/rubrics/#{rubric.id}", attributes_for( :rubric, name: "test", event: event ), { "Authorization" => "Token token=" + SecureRandom.hex }
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
        put "/rubrics/awoifa", attributes_for( :rubric, name: "test", event: event ), { "Authorization" => "Token token=" + user.token.access_token }
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
    let( :rubric ) { create( :rubric ) }
    let( :event ) { create( :event, rubrics: [rubric], organizers: [user] ) }
    describe "with valid attributes", :show_in_doc do
      before :each do
        event.save
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
        event.save
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
        event.save
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
        event.save
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

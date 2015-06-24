require "rails_helper"

describe "Event Categories API" do
  let( :user ) { create( :user ) }
  before { host! "api.example.com" }

  describe "GET /events/:event_id/categories" do
    let( :category_1 ) { create( :event_category ) }
    let( :category_2 ) { create( :event_category ) }
    let( :event ) { create( :event, categories: [ category_1, category_2 ] ) }

    describe "with valid token", :show_in_doc do
      before :each do
        get "/events/#{event.id}/categories", nil, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( json_at_key( response.body, "event_categories" ) ).to eq( serialize_array( EventCategorySerializer, EventCategory.where( event: event ), user ) )
      end
    end

    describe "with invalid token" do
      before :each do
        get "/events/#{event.id}/categories", nil, { "Authorization" => "Token token=" + SecureRandom.hex }
      end

      it "returns an unauthorized status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( "Bad credentials. Token required." )
      end
    end
  end

  describe "POST /events/:event_id/categories" do
    let( :category_1 ) { create( :event_category ) }
    let( :event ) { create( :event, categories: [category_1], organizers: [user] ) }
    describe "with valid attributes", :show_in_doc do
      before :each do
        post "/events/#{event.id}/categories", attributes_for( :event_category ), { "Authorization" => "Token token=" + user.token.access_token } 
      end

      it "returns a created status code" do
        expect( response ).to have_http_status( :created )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( serialize( EventCategorySerializer, EventCategory.last, user ) )
      end
    end

    describe "as a user that did not organize the event" do
      let( :other_user ) { create( :user ) }
      before :each do
        post "/events/#{event.id}/categories", attributes_for( :event_category ), { "Authorization" => "Token token=" + other_user.token.access_token } 
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
        post "/events/#{event.id}/categories", attributes_for( :event_category, label: nil ), { "Authorization" => "Token token=" + user.token.access_token }
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
        post "/events/#{event.id}/categories", nil, { "Authorization" => "Token token=" + SecureRandom.hex }
      end

      it "returns an unauthorized status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( "Bad credentials. Token required." )
      end
    end
  end

  describe "GET /categories/:id" do
    let( :user ) { create( :user ) }
    let( :category ) { create( :event_category ) }
    let( :event ) { create( :event, categories: [category], organizers: [user] ) }
  
    describe "with valid identifier", :show_in_doc do
      before :each do
        event.save
        get "/categories/#{category.id}", nil, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( serialize( EventCategorySerializer, category ) )
      end
    end

    describe "with invalid token" do
      before :each do
        event.save
        get "/categories/#{category.id}", nil, { "Authorization" => "Token token=" + SecureRandom.hex }
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
        get "/categories/awoifa", nil, { "Authorization" => "Token token=" + user.token.access_token }
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
        get "/categories/#{category.id}", nil, { "Authorization" => "Token token=" + other_user.token.access_token }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns the correct JSON" do
        expect( response.body ).to be_blank
      end
    end
  end

  describe "PUT /categories/:id" do
    let( :user ) { create( :user ) }
    let( :category ) { create( :event_category ) }
    let( :event ) { create( :event, categories: [category], organizers: [user] ) }
  
    describe "with valid identifier", :show_in_doc do
      before :each do
        put "/categories/#{category.id}", attributes_for( :event_category, label: "updated", event: event ), { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( serialize( EventCategorySerializer, category.reload ) )
      end

      it "returns updated attributes" do
        expect( json_to_hash( response.body )[:event_category][:label] ).to eq( "updated" )
      end
    end

    describe "with invalid parameters" do
      before :each do
        put "/categories/#{category.id}", attributes_for( :event_category, label: nil, event: event ), { "Authorization" => "Token token=" + user.token.access_token }
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
        put "/categories/#{category.id}", attributes_for( :event_category, label: "test", event: event ), { "Authorization" => "Token token=" + SecureRandom.hex }
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
        put "/categories/awoifa", attributes_for( :event_category, label: "test", event: event ), { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a not found status code" do
        expect( response ).to have_http_status( :not_found )
      end

      it "returns the correct JSON" do
        expect( response.body ).to be_blank
      end
    end
  end

  describe "DELETE /categories/:id" do
    let( :category ) { create( :event_category ) }
    let( :event ) { create( :event, categories: [category], organizers: [user] ) }
    describe "with valid attributes", :show_in_doc do
      before :each do
        event.save
        delete "/categories/#{category.id}", {}, { "Authorization" => "Token token=" + user.token.access_token } 
      end

      it "returns an ok status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( response.body ).to be_blank
      end
    end

    describe "when a team is in the category" do
      let( :team ) { create( :event_team, event: event ) }
      let( :team_category ) { create( :team_category, team: team, category: category ) }

      before :each do
        team_category.save
        event.save
        delete "/categories/#{category.id}", {}, { "Authorization" => "Token token=" + user.token.access_token } 
      end

      it "deletes all teams from the category" do
        expect( TeamCategory.where( category_id: category.id ) ).to be_empty
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
        delete "/categories/#{category.id}", {}, { "Authorization" => "Token token=" + other_user.token.access_token } 
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
        delete "/categories/#{category.id}", nil, { "Authorization" => "Token token=" + SecureRandom.hex }
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
        event.save
        delete "/categories/aowijfoawe", {}, { "Authorization" => "Token token=" + user.token.access_token } 
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

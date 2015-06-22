require "rails_helper"

describe "Team Categories API" do
  let( :user ) { create( :user ) }
  before { host! "api.example.com" }

  describe "GET /teams/:team_id/categories" do
    let( :team_category ) { create( :team_category ) }

    describe "with valid token", :show_in_doc do
      before :each do
        get "/teams/#{team_category.team.id}/categories", nil, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( json_at_key( response.body, "team_categories" ) ).to eq( serialize_array( TeamCategorySerializer, TeamCategory.where( team: team_category.team ), user ) )
      end
    end

    describe "with invalid token" do
      before :each do
        get "/teams/#{team_category.team.id}/categories", nil, { "Authorization" => "Token token=" + SecureRandom.hex }
      end

      it "returns an unauthorized status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( "Bad credentials. Token required." )
      end
    end
  end

  describe "DELETE /teams/:team_id/categories/:id" do
    let( :team_category ) { create( :team_category ) }

    describe "with valid attributes", :show_in_doc do
      before :each do
        team_category.team.event.organizers << user
        team_category.save
        delete "/teams/#{team_category.team.id}/categories/#{team_category.category.id}", {}, { "Authorization" => "Token token=" + user.token.access_token } 
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
        delete "/teams/#{team_category.team.id}/categories/#{team_category.category.id}", {}, { "Authorization" => "Token token=" + other_user.token.access_token } 
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
        delete "/teams/#{team_category.team.id}/categories/#{team_category.category.id}", nil, { "Authorization" => "Token token=" + SecureRandom.hex }
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
        delete "/teams/#{team_category.team.id}/categories/aowijfea", {}, { "Authorization" => "Token token=" + user.token.access_token } 
      end

      it "returns a not found status code" do
        expect( response ).to have_http_status( :not_found )
      end

      it "returns a blank response" do
        expect( response.body ).to be_blank
      end
    end
  end

  describe "POST /teams/:team_id/categories" do
    let( :team_category ) { create( :team_category ) }
    let( :category ) { build( :event_category, event: team_category.team.event ) }

    describe "with valid attributes", :show_in_doc do
      before :each do
        team_category.team.event.organizers << user
        team_category.save
        category.save
        post "/teams/#{team_category.team.id}/categories", { category_id: category.id }, { "Authorization" => "Token token=" + user.token.access_token } 
      end

      it "returns a created status code" do
        expect( response ).to have_http_status( :created )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( serialize( TeamCategorySerializer, TeamCategory.last, user ) )
      end
    end

    describe "as a user that did not organize the event" do
      let( :other_user ) { create( :user ) }
      before :each do
        post "/teams/#{team_category.team.id}/categories", { category_id: category.id }, { "Authorization" => "Token token=" + other_user.token.access_token } 
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
        team_category.team.event.organizers << user
        team_category.save
        post "/teams/#{team_category.team.id}/categories", { category_id: nil }, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns an unprocessable entity status code" do
        expect( response ).to have_http_status( :unprocessable_entity )
      end

      it "returns the correct JSON" do
        expect( json_to_hash( response.body )[:category].first ).to eq( "can't be blank" )
      end
    end

    describe "with invalid token" do
      before :each do
        post "/teams/#{team_category.team.id}/categories", nil, { "Authorization" => "Token token=" + SecureRandom.hex }
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

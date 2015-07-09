require "rails_helper"

describe "Rubric Categories API" do
  let( :user ) { create( :user ) }
  before { host! "api.example.com" }

  describe "GET /rubrics/:rubric_id/categories" do
    let( :rubric_category ) { create( :rubric_category ) }

    describe "with valid token", :show_in_doc do
      before :each do
        get "/rubrics/#{rubric_category.rubric.id}/categories", nil, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( json_at_key( response.body, "rubric_categories" ) ).to eq( serialize_array( RubricCategorySerializer, RubricCategory.where( rubric: rubric_category.rubric ), user ) )
      end
    end

    describe "with invalid token" do
      before :each do
        get "/rubrics/#{rubric_category.rubric.id}/categories", nil, { "Authorization" => "Token token=" + SecureRandom.hex }
      end

      it "returns an unauthorized status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( "Bad credentials. Token required." )
      end
    end
  end

  describe "DELETE /rubrics/:rubric_id/categories/:id" do
    let( :rubric_category ) { create( :rubric_category ) }

    describe "with valid attributes", :show_in_doc do
      before :each do
        rubric_category.rubric.event.organizers << user
        rubric_category.save
        delete "/rubrics/#{rubric_category.rubric.id}/categories/#{rubric_category.category.id}", {}, { "Authorization" => "Token token=" + user.token.access_token } 
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
        delete "/rubrics/#{rubric_category.rubric.id}/categories/#{rubric_category.category.id}", {}, { "Authorization" => "Token token=" + other_user.token.access_token } 
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
        delete "/rubrics/#{rubric_category.rubric.id}/categories/#{rubric_category.category.id}", nil, { "Authorization" => "Token token=" + SecureRandom.hex }
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
        delete "/rubrics/#{rubric_category.rubric.id}/categories/aowijfea", {}, { "Authorization" => "Token token=" + user.token.access_token } 
      end

      it "returns a not found status code" do
        expect( response ).to have_http_status( :not_found )
      end

      it "returns a blank response" do
        expect( response.body ).to be_blank
      end
    end
  end

  describe "POST /rubrics/:rubric_id/categories" do
    let( :rubric_category ) { create( :rubric_category ) }
    let( :category ) { create( :event_category, event: rubric_category.rubric.event ) }

    describe "with valid attributes", :show_in_doc do
      before :each do
        rubric_category.rubric.event.organizers << user
        rubric_category.save
        category.save
        post "/rubrics/#{rubric_category.rubric.id}/categories", { category_id: category.id }, { "Authorization" => "Token token=" + user.token.access_token } 
      end

      it "returns a created status code" do
        expect( response ).to have_http_status( :created )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( serialize( RubricCategorySerializer, RubricCategory.last, user ) )
      end
    end

    describe "as a user that did not organize the event" do
      let( :other_user ) { create( :user ) }
      before :each do
        post "/rubrics/#{rubric_category.rubric.id}/categories", { category_id: category.id }, { "Authorization" => "Token token=" + other_user.token.access_token } 
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
        rubric_category.rubric.event.organizers << user
        rubric_category.save
        post "/rubrics/#{rubric_category.rubric.id}/categories", { category_id: nil }, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns an unprocessable entity status code" do
        expect( response ).to have_http_status( :not_found )
      end

      it "returns the correct JSON" do
        expect( response.body ).to be_blank
      end
    end

    describe "with a category that does not exist" do
      before :each do
        rubric_category.rubric.event.organizers << user
        rubric_category.save
        post "/rubrics/#{rubric_category.rubric.id}/categories", { category_id: 999 }, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns an unprocessable entity status code" do
        expect( response ).to have_http_status( :not_found )
      end

      it "returns the correct JSON" do
        expect( response.body ).to be_blank
      end
    end

    describe "with invalid token" do
      before :each do
        post "/rubrics/#{rubric_category.rubric.id}/categories", nil, { "Authorization" => "Token token=" + SecureRandom.hex }
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

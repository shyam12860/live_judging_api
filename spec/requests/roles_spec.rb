require "rails_helper"

describe "Roles API" do

  before { host! "api.example.com" }

  describe "GET /roles" do
    let( :user ) { create( :user ) }

    describe "with valid token", :show_in_doc do
      before :each do
        get "/roles", nil, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( json_at_key( response.body, "roles" ) ).to eq( serialize_array( RoleSerializer, Role.all ) )
      end
    end

    describe "with invalid token" do
      before :each do
        get "/roles", nil, { "Authorization" => "Token token=" + SecureRandom.hex }
      end

      it "returns an unauthorized status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( "Bad credentials. Token required." )
      end

    end
  end

  describe "GET /roles/:id" do
    let( :user ) { create( :user ) }
    let( :role ) { create( :role ) }
  
    describe "with valid identifier", :show_in_doc do
      before :each do
        get "/roles/#{role.id}", nil, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( RoleSerializer.new( role ).to_json )
      end
    end

    describe "with invalid identifier" do
      before :each do
        get "/roles/baijwf1", nil, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a not found status code" do
        expect( response ).to have_http_status( :not_found )
      end

      it "returns the correct JSON" do
        expect( response.body ).to be_blank
      end
    end

    describe "with invalid token" do
      before :each do
        get "/roles/#{role.id}", nil, { "Authorization" => "Token token=" + SecureRandom.hex }
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

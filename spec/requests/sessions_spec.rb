require "rails_helper"

describe "Sessions API" do

  before { host! "api.example.com" }
  let( :user ) { create( :user ) }

  describe "GET /login" do
    describe "with valid credentials" do
      before :each do
        base_64 = Base64.encode64( user.email + ":" + user.password )
        get "/login", { platform: "iOS" }, { "Authorization" => "Basic " + base_64 }
      end

      it "returns a success status code" do
        expect( response ).to have_http_status( :ok )
      end

      it "has an updated platform" do
        expect( user.reload.platform ).to eq( Platform.find_by( label: "iOS" ) )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( serialize( UserSerializer, user.reload, user ) )
      end
    end

    describe "with tokens" do
      describe "only gcm", :show_in_doc do
        before :each do
          base_64 = Base64.encode64( user.email + ":" + user.password )
          get "/login", { platform: "Android", gcm_token: "gcm_token" }, { "Authorization" => "Basic " + base_64 }
        end

        it "returns a success status code" do
          expect( response ).to have_http_status( :ok )
        end

        it "has an updated token" do
          expect( user.reload.gcm_token ).to eq( "gcm_token" )
        end

        it "returns the correct JSON" do
          expect( response.body ).to eq( serialize( UserSerializer, user.reload, user ) )
        end
      end

      describe "only apn" do
        before :each do
          base_64 = Base64.encode64( user.email + ":" + user.password )
          get "/login", { platform: "iOS", apn_token: "apn_token" }, { "Authorization" => "Basic " + base_64 }
        end

        it "returns a success status code" do
          expect( response ).to have_http_status( :ok )
        end

        it "has an updated token" do
          expect( user.reload.apn_token ).to eq( "apn_token" )
        end

        it "returns the correct JSON" do
          expect( response.body ).to eq( serialize( UserSerializer, user.reload, user ) )
        end
      end

      describe "gcm and apn" do
        before :each do
          base_64 = Base64.encode64( user.email + ":" + user.password )
          get "/login", { platform: "Web", apn_token: "apn_token", gcm_token: "gcm_token" }, { "Authorization" => "Basic " + base_64 }
        end

        it "returns a success status code" do
          expect( response ).to have_http_status( :ok )
        end

        it "has an updated gcm token and apn token" do
          expect( user.reload.gcm_token ).to eq( "gcm_token" )
          expect( user.reload.apn_token ).to eq( "apn_token" )
        end

        it "returns the correct JSON" do
          expect( response.body ).to eq( serialize( UserSerializer, user.reload, user ) )
        end
      end

    end

    describe "with invalid credentials" do
      before :each do
        base_64 = Base64.encode64( "wrong_email@email.com:wrongpassword" )
        get "/login", { platform: "Android" }, { "Authorization" => "Basic " + base_64 }
      end

      it "returns an unauthorized status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( "Bad credentials. Email/Password required." )
      end
    end

    describe "without a platform" do
      before :each do
        base_64 = Base64.encode64( user.email + ":" + user.password )
        get "/login", nil, { "Authorization" => "Basic " + base_64 }
      end

      it "returns an unauthorized status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns the correct JSON" do
        expect( response.body ).to eq( "Must provide a platform" )
      end
    end
  end

  describe "GET /logout" do
    describe "with valid token", :show_in_doc do
      before :each do
        get "/logout", nil, { "Authorization" => "Token token=" + user.token.access_token }
      end

      it "returns a no content status code" do
        expect( response ).to have_http_status( :no_content )
      end

      it "returns no content" do
        expect( response.body ).to be_empty
      end
    end

    describe "with invalid token" do
      before :each do
        get "/logout", nil, { "Authorization" => "Token token=" + SecureRandom.hex }
      end

      it "returns an unauthorized status code" do
        expect( response ).to have_http_status( :unauthorized )
      end

      it "returns no content" do
        expect( response.body ).to eq( "Bad credentials. Token required." )
      end
    end
  end
end

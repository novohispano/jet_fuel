require 'spec_helper'

describe "Server" do
  include Rack::Test::Methods

  def app
    Server
  end

  context "when the user is on the home" do
    it "shows the home" do
      get '/'
      expect(last_response).to be_ok
    end

    it "creates a new shortened url" do
      post '/', { url: "www.test.com" }
      url = Url.find_by_original("www.test.com")
      expect(url.original).to eq "www.test.com"
    end

    it "doesn't create a new shortened url when it already exists" do
      2.times { post '/', { url: "www.test.com" } }
      urls = Url.where(original: "www.test.com")
      expect(urls.count).to eq 1
    end
  end

  context "when the user registers" do
    it "shows the registration page" do
      get '/register'
      expect(last_response).to be_ok
    end

    it "registers a new user" do
      post '/register', { email: "test@test.com", password: "test" }
      user = User.find_by_email("test@test.com")
      expect(user.email).to eq "test@test.com"
    end

    it "doesn't registers a user when the user already exists" do
      2.times { post '/register', { email: "test@test.com", password: "test" } }
      users = User.where(email: "test@test.com")
      expect(users.count).to eq 1
    end
  end

  context "when the user logs in" do
    it "shows the login page" do
      get '/login'
      expect(last_response).to be_ok
    end

    it "logs in the user" do
      post '/register', { email: "test@test.com", password: "test" }
      post '/login', { email: "test@test.com", password: "test" }
      expect(last_response.redirect("dashboard/test@test.com"))
    end

    it "doesn't log the user when password is invalid" do
      post '/register', { email: "test@test.com", password: "test" }
      post '/login', { email: "test@test.com", password: "testtest" }
      expect(last_response.body).to eq "Your password is incorrect"
    end

    it "doesn't log the user when username doesn't exist" do
      post '/login', { email: "test@test.com", password: "test" }
      expect(last_response.body).to eq "Your username doesn't exist"
    end
  end

  context "when the short url is entered" do
    it "redirects to the url page" do
      post '/', { url: "www.test.com" }
      get '/test.com'
      expect(last_response.redirect("http://www.test.com"))
    end

    it "redirects to error page when url doesn't exist" do
      get '/test.com'
      expect(last_response.redirect(:url_error))
    end
  end
end
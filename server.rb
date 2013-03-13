require 'sinatra'
require 'sinatra/activerecord'
require 'erb'
require 'json'

require './models/url'
require './models/user'

ENV['DATABASE_URL'] ||= "sqlite3:///database.sqlite"

class Server < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  set :database, ENV['DATABASE_URL']

  get "/" do
    erb :index
  end

  post "/" do
    original_url = params[:url]

    if Url.exists?(original: original_url)
      @url = Url.where(original: original_url).first
      erb :url_success
    else
      random_url = (0..8).collect{ (65 + rand(26)).chr }.join.downcase
      @url = Url.create(original: original_url, shortened: random_url)
      erb :url_success
    end
  end

  get "/register" do
    erb :register
  end

  post "/register" do
    clear_password = params[:password]
    email          = params[:email]

    if User.exists?(email: email)
      erb :user_error
    else
      salt = (0..8).collect{ (65 + rand(26)).chr }.join.downcase
      password_signer = Digest::HMAC.new(salt, Digest::SHA1)
      salted_password = password_signer.hexdigest(clear_password)

      @user = User.create(email: email, password_hash: salted_password, password_salt: salt)
      erb :user_success
    end
  end

  get "/login" do
    erb :login
  end

  post "/login" do
    clear_password = params[:password]
    email          = params[:email]

    if User.exists?(email: email)
      @user           = User.find_by_email(email)
      salt            = @user.password_salt
      salted_password = @user.password_hash

      password_verifier  = Digest::HMAC.new(salt, Digest::SHA1)
      resulting_password = password_verifier.hexdigest(clear_password)

      if salted_password == resulting_password
        "Success"
      else
        "Your password is incorrect"
      end
    else
      "Your username doesn't exist"
    end
  end

  get '/*' do
    requested_shortened_url = params[:splat].first
    @url = Url.where(shortened: requested_shortened_url).first
    if @url
      redirect to "http://#{@url.original}"
    else
      erb :url_error
    end
  end
end
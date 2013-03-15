require 'sinatra'
require 'sinatra/activerecord'
require 'erb'
require 'json'

require './models/url'
require './models/user'
require './models/request'
require './models/user_url'

ENV['DATABASE_URL'] ||= "sqlite3:///database.sqlite"

class Server < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  set :database, ENV['DATABASE_URL']

  get "/" do
    @urls = Url.all
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

    if email != ""
      if User.exists?(email: email)
        erb :user_error
      else
        salt = (0..8).collect{ (65 + rand(26)).chr }.join.downcase
        password_signer = Digest::HMAC.new(salt, Digest::SHA1)
        salted_password = password_signer.hexdigest(clear_password)

        @user = User.create(email: email, password_hash: salted_password, password_salt: salt)
        erb :user_success
      end
    else
      "You didn't give us a username"
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
        redirect to ("dashboard/#{@user.email}")
      else
        erb :user_error_login_password
      end
    else
      erb :user_error_login_username
    end
  end

  get '/dashboard/:email' do |email|
    @user = User.find_by_email(email)
    @urls = @user.user_urls
    erb :dashboard
  end

  post '/dashboard/:email' do |email, url, vanity_url|
    @user = User.find_by_email(email)

    if @user.user_urls.exists?(shortened: vanity_url)
      erb :user_url_error_vanity
    else
      @user_url = @user.user_urls.create(original: url, shortened: vanity_url)
      erb :user_url_success
    end
  end

  get '/dashboard/:email/:shortened_url' do |email, shortened_url|
    @user = User.find_by_email(email)
    @url  = @user.user_urls.where(shortened: shortened_url).first

    if @url
      value = params
      @url.requests.create(value: value)
      redirect to "http://#{@url.original}"
    else
      erb :url_error
    end
  end

  get '/:shortened_url' do |shortened_url|
    @url = Url.where(shortened: shortened_url).first

    if @url
      value = params
      @url.requests.create(value: value)
      redirect to "http://#{@url.original}"
    else
      erb :url_error
    end
  end
end
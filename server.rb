require 'sinatra'
require 'sinatra/activerecord'
require 'erb'
require 'json'

require './models/url'

ENV['DATABASE_URL'] ||= "sqlite3:///database.sqlite"

class Server < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  set :database, ENV['DATABASE_URL']

  get "/" do
    erb :index
  end

  post "/" do
    original = params[:original_url]
    random_url = (0..8).collect{ (65 + rand(26)).chr }.join.downcase
    if Url.exists?(original: original) == false
      @url = Url.create(original: original, shortened: random_url)
      erb :success
    else
      @url = Url.where(original: original).first
      erb :success
    end
  end

  get '/*' do
    requested_shortened_url = params[:splat].first
    @url = Url.where(shortened: requested_shortened_url).first
    if @url
      redirect to "http://#{@url.original}"
    else
      erb :error
    end
  end
end
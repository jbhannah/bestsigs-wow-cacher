require 'rubygems'
require 'sinatra/base'

require 'net/http'
require 'data_mapper'

class Character
  include DataMapper::Resource

  property :id,         Serial
  property :region,     String
  property :realm,      String
  property :character,  String
  property :img_url,    String
  property :created_at, DateTime
  property :updated_at, DateTime
end

class Web < Sinatra::Base
  configure do
    DataMapper.setup(:default, (ENV["DATABASE_URL"] || "sqlite3:///#{Dir.pwd}/development.sqlite3"))
    DataMapper.auto_upgrade!
  end

  get '/' do
    "Hello world!"
  end

  get '/:region/:realm/:char' do
    q = {
      region: params[:region],
      realm:  params[:realm],
      char:   params[:char]
    }

    uri = URI('http://www.best-signatures.com/api/')
    uri.query = URI.encode_www_form(q)

    uri.to_s
  end
end

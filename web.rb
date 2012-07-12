require 'rubygems'
require 'sinatra/base'
require 'data_mapper'
require './character'

class Web < Sinatra::Base
  configure do
    DataMapper.setup(:default, (ENV["DATABASE_URL"] || "sqlite3:///#{Dir.pwd}/development.sqlite3"))
    DataMapper.auto_upgrade!
  end

  get '/' do
    "Hello world!"
  end

  get '/:region/:realm/:char.png' do
    content_type 'image/png'

    Character.first_or_create({
      region: params[:region],
      realm:  params[:realm],
      char:   params[:char]
    }).fetch_img
  end
end

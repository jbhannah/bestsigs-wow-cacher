require 'rubygems'
require 'sinatra/base'
require 'data_mapper'
require 'character'

class Web < Sinatra::Base
  configure do
    DataMapper.setup(:default, (ENV["DATABASE_URL"] || "sqlite3:///#{Dir.pwd}/development.sqlite3"))
    DataMapper.auto_upgrade!
  end

  set :haml, format: :html5

  get '/' do
    haml :index
  end

  get '/get-character-url' do
    url("/#{params[:region]}/#{params[:realm]}/#{params[:char]}.png")
  end

  get '/:region/:realm/:char.png' do
    content_type 'image/png'

    c = Character.first_or_create({
      region: params[:region],
      realm:  params[:realm],
      char:   params[:char]
    })

    begin
      c.fetch_img
    rescue APINotOkError
      c.destroy
      404
    end
  end
end

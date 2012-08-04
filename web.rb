require 'rubygems'
require 'sinatra/base'
require 'sinatra/synchrony'
require 'data_mapper'
require 'active_support/multibyte/chars'
require 'aws/s3'
require 'character'

class Web < Sinatra::Base
  register Sinatra::Synchrony

  configure do
    DataMapper.setup(:default, (ENV["DATABASE_URL"] || "sqlite3:///#{Dir.pwd}/development.sqlite3"))
    DataMapper.auto_upgrade!

    s3 = AWS::S3.new(
      access_key_id:     ENV["AWS_ACCESS_KEY_ID"],
      secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"])

    bucket_name = "bestsigs-wow-cacher"
    bucket_name += "-development" if development?

    $bucket = s3.buckets[bucket_name]
  end

  set :haml, format: :html5

  get '/' do
    haml :index
  end

  post '/get-character-url' do
    c = Character.first_or_create({
      region: params[:region].downcase,
      realm:  params[:realm].titleize,
      char:   params[:char].capitalize
    })

    begin
      c.update_img

      @url = url("/#{c.region}/#{c.realm}/#{c.char}.png")
      armory_url = "http://#{c.region}.battle.net/wow/en/character/#{c.realm}/#{c.char}/"

      @bbcode  = "[url=\"#{armory_url}\"]"
      @bbcode += "[img]#{@url}[/img]"
      @bbcode += "[/url]"

      haml :get_character_url
    rescue APINotOkError => e
      c.destroy
      "Something went wrong: " + e.message
    end
  end

  get '/:region/:realm/:char.png' do
    content_type 'image/png'

    c = Character.first_or_create({
      region: params[:region].downcase,
      realm:  params[:realm].titleize,
      char:   params[:char].capitalize
    })

    begin
      c.fetch_img
    rescue
      c.destroy
      404
    end
  end
end

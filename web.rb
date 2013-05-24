require 'rubygems'
require 'sinatra/base'
require 'active_support/multibyte/chars'
require 'haml'
require 'maruku'
require 'character'

class Web < Sinatra::Base
  configure :production do
    require 'newrelic_rpm'
    require 'gabba/gabba'

    @@gabba = Gabba::Gabba.new(ENV["GA_TRACKING_ID"], "bestsigs-wow-cacher.herokuapp.com")
  end

  configure :production, :development do
    enable :logging
  end

  set :haml, format: :html5

  get '/' do
    haml :index
  end

  get '/stats' do
    @stats = {
      count:   Character.count,
      regions: Character.aggregate(:all.count, fields: [:region]).sort         { |x,y| y[1] <=> x[1] },
      realms:  Character.aggregate(:all.count, fields: [:region, :realm]).sort { |x,y| y[2] <=> x[2] }
    }

    @stats[:regions].each do |region|
      region << Character.aggregate(:all.count, fields: [:realm], conditions: [ 'region = ?', region[0] ]).count
    end

    haml :stats
  end

  post '/get-character-url' do
    begin
      c = Character.first_or_create({
        region: params[:region].downcase,
        realm:  params[:realm].titleize,
        char:   params[:char].capitalize
      })

      c.update_img

      @url = url("/#{c.char_path}.png")
      armory_url = "http://#{c.region}.battle.net/wow/en/character/#{c.realm}/#{c.char}/"

      @bbcode  = "[url=\"#{armory_url}\"]"
      @bbcode += "[img]#{@url}[/img]"
      @bbcode += "[/url]"

      if defined?(@@gabba)
        @@gabba.ip(request.ip)
        @@gabba.page_view("Get character URL: #{c.char} (#{c.realm}-#{c.region.upcase})",
                         request.path + "?region=#{c.region}&realm=#{c.realm}&char=#{c.char}")
      end

      haml :get_character_url
    rescue Exception => e
      c.destroy if c
      "Something went wrong: " + e.message
    end
  end

  get '/:region/:realm/:char.png' do
    begin
      c = Character.first_or_create({
        region: params[:region].downcase,
        realm:  params[:realm].titleize,
        char:   params[:char].capitalize
      })

      if defined?(@@gabba)
        @@gabba.ip(request.ip)
        @@gabba.page_view("#{c.char} (#{c.realm}-#{c.region.upcase})", "/#{c.char_path}.png")
      end

      redirect c.img_uri, 303
    rescue Exception => e
      c.destroy if c
      logger.error "#{e.class}: #{e.message}"
      404
    end
  end
end

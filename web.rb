require 'rubygems'
require 'sinatra/base'

require 'net/http'

class Web < Sinatra::Base
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

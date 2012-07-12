require 'net/http'

class Character
  include DataMapper::Resource

  property :id,         Serial
  property :region,     String
  property :realm,      String
  property :char,       String
  property :api_url,    String
  property :img_url,    String
  property :created_at, DateTime
  property :updated_at, DateTime

  def fetch_img
    q = {
      region: region,
      realm:  realm,
      char:   char
    }

    uri = URI('http://www.best-signatures.com/api/')
    uri.query = URI.encode_www_form(q)

    uri.to_s
  end
end

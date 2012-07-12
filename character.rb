require 'net/http'

class Character
  include DataMapper::Resource

  before :create, :set_api_uri

  property :id,         Serial
  property :region,     String
  property :realm,      String
  property :char,       String
  property :api_url,    String
  property :img_url,    String
  property :region,     String, required: true
  property :realm,      String, required: true
  property :char,       String, required: true
  property :api_uri,    URI
  property :img_uri,    URI
  property :created_at, DateTime
  property :updated_at, DateTime

  def fetch_img
    api_uri.to_s
  end

  private
  def set_api_uri
    q = {
      region: region,
      realm:  realm,
      char:   char
    }

    uri = URI('http://www.best-signatures.com/api/')
    uri.query = URI.encode_www_form(q)

    self.api_uri = uri
  end
end

require 'active_support/core_ext'
require 'net/http'
require 'json'

class Character
  include DataMapper::Resource

  before :create, :set_api_uri

  property :id,         Serial
  property :region,     String, required: true
  property :realm,      String, required: true
  property :char,       String, required: true
  property :api_uri,    URI
  property :img_uri,    URI
  property :created_at, DateTime
  property :updated_at, DateTime

  def fetch_img
    if updated_at < 6.hours.ago or img_uri.nil?
      update_img_uri
    end

    Net::HTTP.get(img_uri)
  end

  private
  def set_api_uri
    q = {
      region: region,
      realm:  realm,
      char:   char,
      type:   "Sign9"
    }

    uri = URI('http://www.best-signatures.com/api/')
    uri.query = URI.encode_www_form(q)

    self.api_uri = uri
  end

  def update_img_uri
    json = JSON.parse(Net::HTTP.get(api_uri))
    raise if json["status"] != "ok"

    self.update img_uri: json["link"]
  end
end

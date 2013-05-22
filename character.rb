require 'active_support/core_ext'
require 'net/http'
require 'json'

class APINotOkError < StandardError
end

class Character
  include DataMapper::Resource

  before :create, :cleanup
  before :create, :titleize

  before :destroy do
    img_s3.delete
  end

  property :id,         Serial
  property :region,     String, required: true, format: /^[a-z]{2}$/
  property :realm,      String, required: true
  property :char,       String, required: true, format: /^[[:alpha:]]+$/
  property :img_uri,    URI
  property :created_at, DateTime
  property :updated_at, DateTime

  def fetch_img
    begin
      update_img
    rescue Exception => e
      raise e if img_uri.nil?
    end

    img_uri
  end

  def update_img
    return unless updated_at < 3.hours.ago or img_uri.nil?

    json = JSON.parse(Net::HTTP.get(api_uri))
    if json["status"] != "ok"
      msg = "API status not ok for #{region}/#{realm}/#{char}"
      msg += ": " + json["msg"] if json["msg"]
      raise APINotOkError, msg
    end

    self.update img_uri: URI(json["link"]), updated_at: Time.now
  end

  private
  def cleanup
    Character.all(:updated_at.lt => 1.week.ago).each { |c| c.destroy } if Character.count > 9000
  end

  def titleize
    self.region = region.downcase
    self.realm  = realm.titleize
    self.char   = char.capitalize
  end

  def api_uri
    uri = URI('http://www.best-signatures.com/api/')
    uri.query = URI.encode_www_form({
      region: region,
      realm:  realm,
      char:   char,
      type:   "Sign9"
    })

    return uri
  end
end

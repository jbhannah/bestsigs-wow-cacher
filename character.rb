require 'active_support/core_ext'
require 'net/http'
require 'json'

class APINotOkError < StandardError
end

class Character
  include DataMapper::Resource

  before :create, :cleanup
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
    begin
      update_img_uri
    rescue Exception => e
      raise e if img_uri.nil?
    end

    img_s3.read
  end

  def update_img_uri
    return unless updated_at < 3.hours.ago or img_uri.nil?

    json = JSON.parse(Net::HTTP.get(api_uri))
    if json["status"] != "ok"
      msg = "API status not ok for #{region}/#{realm}/#{char}"
      msg += ": " + json["msg"] if json["msg"]
      raise APINotOkError, msg
    end

    self.update img_uri: json["link"]
    img_s3.write(Net::HTTP.get(img_uri))
  end

  private
  def cleanup
    Character.all(:updated_at.lt => 1.week.ago).each { |c| c.destroy } if Character.count > 5000
  end

  def set_api_uri
    uri = URI('http://www.best-signatures.com/api/')
    uri.query = URI.encode_www_form({
      region: region,
      realm:  realm,
      char:   char,
      type:   "Sign9"
    })

    self.api_uri = uri
  end

  def img_s3
    $bucket.objects["#{region}/#{realm}/#{char}.png"]
  end
end

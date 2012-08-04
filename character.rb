require 'active_support/core_ext'
require 'net/http'
require 'json'

class APINotOkError < StandardError
end

class Character
  include DataMapper::Resource

  before :create,  :cleanup
  before :create,  :titleize

  before :destroy do
    img_s3.delete
  end

  property :id,         Serial
  property :region,     String, required: true
  property :realm,      String, required: true
  property :char,       String, required: true
  property :created_at, DateTime
  property :updated_at, DateTime

  def fetch_img
    begin
      update_img
    rescue Exception => e
      raise e unless img_s3.exists?
    end

    img_s3.read
  end

  def update_img
    return unless updated_at < 3.hours.ago or not img_s3.exists?

    json = JSON.parse(Net::HTTP.get(api_uri))
    if json["status"] != "ok"
      msg = "API status not ok for #{region}/#{realm}/#{char}"
      msg += ": " + json["msg"] if json["msg"]
      raise APINotOkError, msg
    end

    img_s3.write(Net::HTTP.get URI(json["link"]))
    self.update updated_at: Time.now
  end

  private
  def cleanup
    Character.all(:updated_at.lt => 1.week.ago).each { |c| c.destroy } if Character.count > 5000
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

  def img_s3
    $bucket.objects["#{region}/#{realm}/#{char}.png"]
  end
end

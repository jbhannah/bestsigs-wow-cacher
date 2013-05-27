require 'active_support/core_ext'
require 'aws/s3'
require 'data_mapper'
require 'net/http'
require 'json'

class APINotOkError < StandardError
end

class Character
  class << self
    def bucket
      bucket_name = "bestsigs-wow-cacher"
      bucket_name += "-development" if ENV["RACK_ENV"] == "development"

      @@bucket ||= AWS::S3.new(
        access_key_id:     ENV["AWS_ACCESS_KEY_ID"],
        secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]).buckets[bucket_name]
      @@bucket
    end

    def dm_setup
      DataMapper::Model.raise_on_save_failure = true
      DataMapper.setup(:default, (ENV["DATABASE_URL"] || "sqlite3:///#{Dir.pwd}/development.sqlite3"))
      DataMapper.auto_upgrade!
    end
  end

  include DataMapper::Resource

  before :create, :titleize

  property :id,         Serial
  property :region,     String, required: true, format: /^[a-z]{2}$/
  property :realm,      String, required: true
  property :char,       String, required: true, format: /^[[:alpha:]]+$/
  property :created_at, DateTime
  property :updated_at, DateTime

  def char_path
    "#{region}/#{realm}/#{char}"
  end

  def img_uri
    begin
      update_img
    rescue Exception => e
      raise e unless img_s3.exists?
    end

    img_s3.acl = :public_read
    img_s3.public_url
  end

  def update_img
    return unless updated_at < 3.hours.ago or not img_s3.exists?

    json = JSON.parse(Net::HTTP.get(api_uri))
    raise APINotOkError, json["msg"] unless json["status"] == "ok"

    img_s3.write(Net::HTTP.get URI(json["link"]))
    self.update updated_at: Time.now
  end

private
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
    Character.bucket.objects["#{char_path}.png"]
  end
end

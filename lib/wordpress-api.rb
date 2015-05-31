require 'net/http'
require 'json'

class WordPress
	def initalize
	end

	def self.set_source(source)
    @source = source
  end

  def self.query_url(uri)
  	begin
  		data = Net::HTTP.get(uri)
  	rescue
  		puts "There was an error with the provided URL: #{uri}"
  	end
  end

  def self.query_load_json(source, endpoint, params)
		url = URI("#{source}/#{endpoint}/")
		url.query = URI.encode_www_form(params)
  	data = self.query_url(url)
  	content = JSON.load(data)
  	return content
  end

end

require_relative 'community'
require_relative 'jetpack'
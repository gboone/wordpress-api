require 'open-uri'
require 'json'

class WordPress
  def self.hi
    puts "Hello world!"
  end

  def self.set_source(source)
    @source = source
  end

  def self.get_posts(source, count = nil)
		unless count.nil?
			data = open("#{source}posts/")
		else
			data = open("#{source}posts/?filter[posts_per_page]=#{count}")
		end
		wpposts = JSON.load(data)
	end

	def self.get_post(source, post)
		data = open("#{source}posts/#{post}")
		post = JSON.load(data)
	end

	def self.get_media(source)
		data = open("#{source}media/")
		media = JSON.load(data)
	end

	def self.get_taxonomies(source)
		data = open("#{source}/taxonomies")
		taxonomies = JSON.load(data)
	end
	
	def self.get_taxonomy(source, taxonomy)
		data = open("#{source}/taxonomies/#{taxonomy}")
		taxonomy = JSON.load(data)
	end

	def self.get_terms(source, taxonomy)
		data = open("#{source}/taxonomies/#{taxonomy}/terms")
		terms = JSON.load(data)
	end

	def self.get_term(source, taxonomy, term)
		data = open("#{source}/taxonomies/#{taxonomy}/terms/#{term}")
		term = JSON.load(data)
	end
end

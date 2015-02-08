require 'net/http'
require 'json'

class WordPress

  def self.hi
  	puts 'hello world'
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

  def self.prepare_query(params)
  	args = Hash.new
  	begin
	  	if params.is_a?(Hash)
	  		params.each{|x| 
	  			filter = "filter[#{x[0]}]";
	  			arg = {filter => x[1]};
	  			args = args.merge(arg);
	  			return args
	  		}
	  	end
  	rescue
  		puts "Something is wrong, perhaps you did not pass a hash."
  	end
  end

  # Get Posts from a wordpress source
  #
  # Requires:
  # source (str): the url to the root API endpoint
  # params (hash): a hash of parameters to filter by
  #
  # Note, the hash for the params argument should be formed like this:
  #
  # params = {'posts_per_page'=>'1','order'=>'ASC'}
  #
  # Even though WordPress requires the "filter" argument, we will prepend that
  # for you in this method.
  #
  def self.get_posts(source, params = nil)
		begin
			if params.nil?
				url = URI("#{source}posts/")
			else
				url = URI("#{source}posts/")
				args = prepare_query params
				require 'pry'; binding.pry
				url.query = URI.encode_www_form(args)
			end
		rescue
			puts "something is wrong with your url: #{source} or parameters. 
			      Make sure they're an array."
		end
		data = self.query_url(url)
		wpposts = JSON.load(data)
		wpposts
	end

	def self.get_post(source, post)
		url = URI("#{source}posts/#{post}")
		data = Net::HTTP.get(url)
		post = JSON.load(data)
	end

	def self.get_media(source)
		url = URI("#{source}media/")
		data = Net::HTTP.get(url)
		media = JSON.load(data)
	end

	def self.get_taxonomies(source)
		url = URI("#{source}/taxonomies")
		data = Net::HTTP.get(url)
		taxonomies = JSON.load(data)
	end
	
	def self.get_taxonomy(source, taxonomy)
		url = URI("#{source}/taxonomies/#{taxonomy}")
		data = Net::HTTP.get(url)
		taxonomy = JSON.load(data)
	end

	def self.get_terms(source, taxonomy)
		url = URI("#{source}/taxonomies/#{taxonomy}/terms")
		data = Net::HTTP.get(url)
		terms = JSON.load(data)
	end

	def get_term(source, taxonomy, term)
		url = URI("#{source}/taxonomies/#{taxonomy}/terms/#{term}")
		data = Net::HTTP.get(url)
		term = JSON.load(data)
	end
end

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
  	if params.is_a?(Hash)
  		params.each{|x| 
  			filter = "filter[#{x[0]}]";
  			arg = {filter => x[1]};
  			args = args.merge(arg);
  			return args
  		}
  	else
  		raise RuntimeError, "Something is wrong, perhaps you did not pass a hash."
  	end
  end

  def self.query_load_json(source, endpoint, params)
		url = URI("#{source}#{endpoint}/")
  	if params
  		args = prepare_query params	
  		url.query = URI.encode_www_form(args)
  	end
  	data = self.query_url(url)
  	content = JSON.load(data)
  	return content
  end

  # Get Posts from a WordPress source
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
  def self.get_posts(source, params = nil, post = nil)
		if post.nil?
			wpposts = self.query_load_json(source, "posts", params)
		else
			wpposts = self.get_post(source, post)
		end
	end

	def self.get_post(source, post)
		posts = self.query_load_json(source, "posts/#{post}", params = nil)
	end

	# Get Media from a WordPress source
  #
  # By default gets the 9 most recent media objects from the WordPress site. If
  # passed optional parameters, will filter those posts accordingly. Like 
  # get_posts, this should be passed as a hash. If a specific attachment is 
  # given as the third parameter, it will return only that attachment's object
  # and the `params` hash will be ignored (if passed)
  #
  # Requires:
  # source (str): the url to the root API endpoint
  # attachment (int, optional): a specific attachment to get
  # params (hash, optional): a hash of parameters to filter by
  #
  # Note, the hash for the params argument should be formed like this:
  #
  # params = {'posts_per_page'=>'1','order'=>'ASC'}
  #
  # Even though WordPress requires the "filter" argument, we will prepend that
  # for you in this method.

	def self.get_media(source, params = nil, attachment = nil)
		if attachment
			posts = get_attachment(source, attachment)
		else
			posts = self.query_load_json(source, "media", params)
		end
	end

	def self.get_attachment(source, attachment)
		posts = self.query_load_json(source, "media/#{attachment}")
	end

	# Get Taxonomies from a WordPress source
  #
  # By default, returns all taxonomies registered in the WordPress database.
  #
  # If passed a hash of parameters, will filter the taxonomies accordingly. 
  # (See wp-json documentation at http://wp-api.org/#taxonomies_retrieve-all-taxonomies)
  #
  # Requires:
  # source (str): the url to the root API endpoint
  #
  # Optional
  # attachment (int): a specific attachment to get
  # params (hash): a hash of parameters to filter by (currently no filters are 
  #	documented at wp-api.org)
  #
  # Note, the hash for the params argument should be formed like this:
  #
  # params = {'posts_per_page'=>'1','order'=>'ASC'}
  #
  # Even though WordPress requires the "filter" argument, we will prepend that
  # for you in this method.

	def self.get_taxonomies(source, params = nil, taxonomy = nil)
		if taxonomy
			get_taxonomy(source, taxonomy)
		else
			taxonomies = self.query_load_json(source, "taxonomies")
		end
	end
	
	def self.get_taxonomy(source, taxonomy)
		taxonomy = self.query_load_json(source, "taxonomies/#{taxonomy}")
	end

	# Get terms
	#
	# Retrieves all terms associated with a given taxonomy.
	#
	# Requires:
	# source (str): the url to the root API endpoint
	# taxonomy (str): the taxonomy from which to retrieve terms
	#
	# Optional:
	# term (str): the slug of the term to retrieve

	def self.get_terms(source, taxonomy, term = nil)
		if term
			terms = get_term(source, taxonomy, term)
		else
			terms = self.query_load_json(source, "/taxonomies/#{taxonomy}/terms")
		end
	end

	def get_term(source, taxonomy, term)
		term = self.query_load_json(source, "/taxonomies/#{taxonomy}/terms/#{term}")
	end
end

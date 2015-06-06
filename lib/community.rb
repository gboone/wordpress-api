# Querys a self-hosted WordPress site
#
# Requires the site have WP-API/WP-API installed.
class Community < WordPress
  def initialize
  end

  # Get Posts from a WordPress source
  #
  # Requires:
  # source (str): the url to the root API endpoint
  # params (hash): a hash of parameters to filter by
  #
  # Note, the hash for the params argument should be formed like this:
  #
  # params = {'per_page'=>'1','order'=>'ASC'}
  #
  # Most query parameters follow the naming conventions found in the Codex with
  # the exception of "posts_per_page" which must be `per_page` and `paged`
  # which must be `page` in api calls.
  #
  def get_posts(source, params = Hash.new, post = nil)
    if post
			wpposts = WordPress.get_post(source, post)
    else
      # args = self.prepare_query(params)
      wpposts = WordPress.query_load_json(source, "posts", params)
		end
	end

  # Gets a post by its ID
  #
  # WordPress's built-in get_post function requires you to pass an ID, but you 
  # might not have one if your staging and production databases are out of sync
  # (for example). IF all you have is a slug, you'll want to find another way of
  # getting post ID.
  #
	def get_post(source, post)
		posts = WordPress.query_load_json(source, "posts/#{post}", params = nil)
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

	def get_media(source, params = nil, attachment = nil)
		if attachment
			posts = get_attachment(source, attachment)
		else
			posts = WordPress.query_load_json(source, "media", params)
		end
	end

	def get_attachment(source, attachment)
		posts = WordPress.query_load_json(source, "media/#{attachment}")
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

	def get_taxonomies(source, params = nil, taxonomy = nil)
		if taxonomy
			get_taxonomy(source, taxonomy)
		else
			taxonomies = WordPress.query_load_json(source, "taxonomies")
		end
	end
	
	def get_taxonomy(source, taxonomy)
		taxonomy = WordPress.query_load_json(source, "taxonomies/#{taxonomy}")
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

	def get_terms(source, taxonomy, term = nil)
		if term
			terms = get_term(source, taxonomy, term)
		else
			terms = WordPress.query_load_json(source, "/taxonomies/#{taxonomy}/terms")
		end
	end

	def get_term(source, taxonomy, term)
		term = WordPress.query_load_json(source, "/taxonomies/#{taxonomy}/terms/#{term}")
	end
end
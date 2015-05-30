require 'net/http'
# Queries the WordPress.com API
#
# Requires the site be hosted on WordPress.com or have the 
# JSON API feature turned on in Jetpack.
class Jetpack < WordPress
  def initialize(source)
    @base = "https://public-api.wordpress.com/"
    @blog = source
    @source = "#{@base}/rest/v1.1/sites/#{@blog}"
  end

  def authenticate(id, redir, response, secret, global = false)
    unless global
      blog = @blog
    else
      blog = "global"
    end
    params = {
      "client_id"=>id,
      "redirect_uri"=>redir,
      "response_type"=>response,
      "blog"=>blog,
    }
    url = URI("#{@base}/oauth2/authorize")
    url.query = URI.encode_www_form(params)
    data = Net::HTTP.get(url)

  end
  
  def prepare_query(args)
  end

  def get_posts()
  end

  def get_post()
  end

  def get_media()
  end

  def get_attachment()
  end

  def get_taxonomies()
  end

  def get_taxonomy()
  end

  def get_terms()
  end

  def get_term()
  end
end
require 'wordpress-api'
require 'net/http'
# Tests expect the following environment variables:
#
# - WPHOST: for testing self-hosted sites, the base URL for your WordPress site
# - WPSECRET: for testing WordPress.com authentication, the secret key
# - WPBLOG: for testing WordPress.com, the blog you're targeting
RSpec.describe WordPress, "#source" do 
  context "with no endpoint set" do
    it "sets the source of an API endpoint" do
      source = WordPress.set_source('https://example.com')
      expect(source).to eq 'https://example.com'
    end
  end
end

RSpec.describe WordPress, "#query_url" do
  context "with a valid URL" do
    it "querys the specified url and returns the result" do
      uri = URI("#{ENV['WPHOST']}/wp-json/wp/v2")
      body = WordPress.query_url(uri)
      expect(body).to be_a(String)
    end
  end
end

RSpec.describe WordPress, "#query_load_json" do
  context "given a url, endpoint, and parameters" do
    it "queries the url at the specified endpoint and returns the appropariate object" do
      url = "#{ENV['WPHOST']}"
      endpoint = "/wp-json/wp/v2/posts"
      params = {"per_page"=>"1"}
      args = WordPress.query_load_json(url, endpoint, params)
      expect(args.length).to eq(1)
    end
  end
end

RSpec.describe Community, "#get_posts" do
  context "with no parameters" do
    it "queries the specified url for posts and returns an array" do
      c = Community.new
      posts = c.get_posts("#{ENV['WPHOST']}/wp-json/wp/v2/")
      expect(posts).to be_an(Array)
    end
  end

  context "with a hash of parameters" do
    it "queries the specified url with a valid hash of parameters" do
      params = {"per_page"=>"1"}
      c = Community.new
      posts = c.get_posts("#{ENV['WPHOST']}/wp-json/wp/v2/", params)
      expect(posts).to be_an(Array)
      expect(posts[0]['id']).to be_an(Integer)
    end
  end

  context "with a hash of multiple parameters" do
    it "queries the specified url with a valid hash of more than one query parameters" do
      params = {
        "per_page"=>"2",
        "page"=>"2"
      }
      c = Community.new
      posts = c.get_posts("#{ENV['WPHOST']}/wp-json/wp/v2/", params)
      expect(posts).to be_an(Array)
      expect(posts.length).to eq(2)
      expect(posts[0]['id']).to be_an(Integer)
      expect(posts[1]['id']).to be_an(Integer)
    end
  end
end

RSpec.describe Community, "#get_post" do
  context "with a specified post" do
    it "will query the url and return the post object as json" do
      id = 1
      c = Community.new
      post = c.get_post("#{ENV['WPHOST']}/wp-json/wp/v2/", id)
      expect(post['id']).to eq(1)
    end
  end

  context "get post meta data", :broken => true do
    it "will query the url and return any custom fields attached to the post" do
      id = 1
      meta = Community.new.get_post_meta("#{ENV['WPHOST']}/wp-json/wp/v2/", id)
      require 'pry'; binding.pry
    end
  end
end

RSpec.describe Jetpack, :broken => true do
  
  context "with proper credentials" do
    it "will authenticate a user to access a given blog" do
      id = 39388
      redir = ENV['WPHOST']
      response = "code"
      secret = ENV['WPSECRET']
      j = Jetpack.new(ENV['WPBLOG'])
      j.authenticate(id, redir, response, secret)
    end
  end
end

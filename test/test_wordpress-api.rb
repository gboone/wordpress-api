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
      uri = URI("#{ENV['WPHOST']}/wp-json/")
      body = WordPress.query_url(uri)
      expect(body).to be_a(String)
    end
  end
end

RSpec.describe WordPress, "#prepare_query" do
  context "with a Hash containing query parameters" do
    it "prepares the hash for processing as query parameters" do
      params = {"posts_per_page" => "1"}
      c = Community.new
      args = c.prepare_query(params)
      expected = {"filter[posts_per_page]"=>"1"}
      expect(args).to eq(expected)
    end
  end
  context "with a Hash containing multiple query parameters" do
    it "prepares the hash for processing as query parameters" do
      params = { "posts_per_page" => "1", "author" => "gboone" }
      c = Community.new
      args = c.prepare_query(params)
      expected = {
        "filter[posts_per_page]" => "1",
        "filter[author]" => "gboone"
      }
      expect(args).to eq(expected)
    end
  end
end

RSpec.describe WordPress, "#query_load_json" do
  context "given a url, endpoint, and parameters" do
    it "queries the url at the specified endpoint and returns the appropariate object" do
      url = "#{ENV['WPHOST']}/wp-json/"
      endpoint = "posts"
      params = {"filter[posts_per_page]"=>"1"}
      args = WordPress.query_load_json(url, endpoint, params)
      expect(args.length).to eq(1)
    end
  end
end

RSpec.describe Community, "#get_posts" do
  context "with no parameters" do
    it "queries the specified url for posts and returns an array" do
      c = Community.new
      posts = c.get_posts("#{ENV['WPHOST']}/wp-json/")
      expect(posts).to be_an(Array)
    end
  end

  context "with a hash of parameters" do
    it "queries the specified url with a valid hash of parameters" do
      params = {"posts_per_page"=>1}
      c = Community.new
      posts = c.get_posts("#{ENV['WPHOST']}/wp-json/", params)
      expect(posts).to be_an(Array)
    end
  end
end

RSpec.describe Community, "#get_post" do
  context "with a specified post" do
    it "will query the url and return the post object as json" do
    end
  end
end

RSpec.describe Jetpack, "#auth" do
  
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

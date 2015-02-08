require 'wordpress-api'
require 'net/http'
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
      uri = URI("http://www.wordpress.com/wp-json/")
      body = WordPress.query_url(uri)
      expect(body).to be_a(String)
    end
  end
end

RSpec.describe WordPress, "#prepare_query" do
  context "with a Hash containing query parameters" do
    it "prepares the hash for processing as query parameters" do
      params = {"posts_per_page" => "1"}
      args = WordPress.prepare_query(params)
      expected = {"filter[posts_per_page]"=>"1"}
      expect(args).to eq(expected)
    end
  end
end

RSpec.describe WordPress, "#query_load_json" do
  context "given a url, endpoint, and optionally parameters" do
    it "queries the url at the specified endpoint and returns the appropariate object" do
      url = "https://www.wordpress.org/wp-json/"
      endpoint = "posts"
      params = {"posts_per_page"=>"1"}
      args = WordPress.query_load_json(url, endpoint, params)
      expect(args.length).to eq(1)
    end
  end
end

RSpec.describe WordPress, "#get_posts" do
  context "with no parameters" do
    it "queries the specified url for posts and returns an array" do
      posts = WordPress.get_posts('https://www.wordpress.org/wp-json/')
      expect(posts).to be_an(Array)
    end
  end

  context "with a hash of parameters" do
    it "queries the specified url with a valid hash of parameters" do
      params = {"posts_per_page"=>1}
      posts = WordPress.get_posts('https://www.wordpress.org/wp-json/', params)
      expect(posts).to be_an(Array)
    end
  end
end

RSpec.describe WordPress, "#get_post" do
  context "with a specified post" do
    it "will query the url and return the post object as json" do
    end
  end
end

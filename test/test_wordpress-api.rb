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
# RSpec.describe WordPress, "#get_posts" do
#   context "with no parameters" do
#     it "querys the specified url for posts and returns an array" do
#       posts = WordPress.get_posts('https://www.harmsboone.org/wp-json/')
#       expect(posts).to be_an(Array)
#     end
#   end
#   context "with invalid url" do
#     it "querys the specified url and returns an error" do
#       posts = WordPress.get_posts('https://example.com')
#       expect(posts).to raise_error
#     end
#   end
# end
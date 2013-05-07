require 'net/http'
require 'json'
require 'uri'


class HomeController < ApplicationController
  def index


  	@tweets = []

  	uri = URI('http://search.twitter.com/search.json?q=blizzard&include_entities=true&result_type=mixed')
  	@http_response = Net::HTTP.get(uri) # => String

  	@twitter_response = JSON.parse(@http_response)

  	@twitter_response["results"].each { |tweet_json| 
  		@tweets.push(Tweet.new(tweet_json))
  	}

  	@is_image = is_url_image?('http://i.imgur.com/Xkt8Cno.jpg')

  	puts forward_url('http://t.co/o5mQqanp6c')

  	#uri = URI('http://example.com/index.html')
	#params = { :limit => 10, :page => 3 }
	#uri.query = URI.encode_www_form(params)

  end

  def is_url_image?(url)
	uri = URI(url)

	req = Net::HTTP::Head.new(uri.path)

	response = Net::HTTP.start(uri.host, uri.port) do |http|
	  http.request(req)
	end

	puts "URL: " + url
	puts "Code: " + response.code
	response.each{ |k, v| puts "#{k} => #{v}"}

	if response.code == "200" and response.key?("content-type")
		return response["content-type"].starts_with?("image")
	else
		return false
	end
  end


  def forward_url(url)
  	while true do

  		puts "looped"
		uri = URI(url)

		req = Net::HTTP::Head.new(uri.path)

		puts "URI: " + uri.to_s
		puts uri.to_json
		puts "query"
		puts uri.query
		puts "bleh"

		response = Net::HTTP.start(uri.host, uri.port) do |http|
		  http.request(req)
		end

		if response.code.starts_with?("3") and response.key?("location")
			url = response["location"]
		else
			puts response.code
			return url
		end
	end
  end

end





require 'net/http'
require 'json'
require 'uri'


class HomeController < ApplicationController
  @@forward_cache = {}
  @@is_image_cache = {}

  def index
  end


  def search
  	q = params["q"]

	uri = URI("http://search.twitter.com")
	uri.path = "/search.json"
	uri.query = "q=" + URI.encode_www_form_component(q) +  "&result_type=mixed&include_entities=true"


	puts uri

	count = 1

  	@tweets = []

  	@http_response = Net::HTTP.get(uri)

  	@twitter_response = JSON.parse(@http_response)

  	@twitter_response["results"].each { |tweet_json| 
  		@tweets.push(Tweet.new(tweet_json))
  	}

  	@tweets.each{|tweet|
  		tweet.div_id = "tweet_" + count.to_s
  		count += 1
  		if tweet.entities.key?("urls")
  			tweet.entities["urls"].each{ |url_hash|
  				tweet.links.push(url_hash["expanded_url"])
  			}
  		end
  		if tweet.entities.key?("media")
  			tweet.entities["media"].each{ |media_hash|
  				if(media_hash["type"] == "photo")
  					tweet.twitter_images.push(media_hash["media_url"])
  				end
  			}
  		end
  	}

  	render :layout => false

  end

  def getImage
	if @@forward_cache.key?(params["url"])
		url = @@forward_cache[params["url"]]
	else
		url = forward_url(params["url"])
		@@forward_cache[params["url"]] = url
	end

	if !@@is_image_cache.key?(url)
		@@is_image_cache[url] = is_url_image?(url)
	end	

	if @@is_image_cache[url]
		render :inline => '<img src="' + url +'" alt="bleh" />'
	else
		render :nothing => true
	end  	
  end


  def is_url_image?(url)
	uri = URI(url)

	if uri.query != nil
		req = Net::HTTP::Head.new(uri.path+ '?' + uri.query)
	elsif uri.path != nil and uri.path != ''
		req = Net::HTTP::Head.new(uri.path)
	else
		req = Net::HTTP::Head.new('/')
	end

	begin
		response = Net::HTTP.start(uri.host, uri.port) do |http|
		  http.request(req)
		end
	rescue
		return false
	end

	if response.code == "200" and response.key?("content-type")
		return response["content-type"].starts_with?("image")
	else
		return false
	end
  end


  def forward_url(url)
  	while true do

		uri = URI(url)

		if uri.query != nil
			req = Net::HTTP::Head.new(uri.path+ '?' + uri.query)
		elsif uri.path != nil and uri.path != ''
			req = Net::HTTP::Head.new(uri.path)
		else
			req = Net::HTTP::Head.new('/')
		end

		begin
			response = Net::HTTP.start(uri.host, uri.port) do |http|
			  http.request(req)
			end
		rescue
			return url
		end

		if response.code.starts_with?("3") and response.key?("location")
			url = response["location"]
		else
			return url
		end
	end
  end

end





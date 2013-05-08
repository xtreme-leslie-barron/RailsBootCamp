class Tweet
	PROPERTIES = [:from_user, :text, :created_at, :profile_image_url, :entities]

	PROPERTIES.each { |property|
		attr_accessor property
	}

	attr_accessor :twitter_images
	attr_accessor :links
	attr_accessor :div_id

	def initialize(attributes = {})
		attributes.each { |key, value|
			self.send("#{key}=", value) if PROPERTIES.member? key.to_sym
		}

		@links = []
		@twitter_images = []
		@div_id = ""
	end
end
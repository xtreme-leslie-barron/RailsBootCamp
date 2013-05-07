class Tweet
	PROPERTIES = [:from_user, :text, :created_at, :profile_image_url, :entities]

	PROPERTIES.each { |property|
		attr_accessor property
	}

	def initialize(attributes = {})
		attributes.each { |key, value|
			self.send("#{key}=", value) if PROPERTIES.member? key.to_sym
		}
	end
end
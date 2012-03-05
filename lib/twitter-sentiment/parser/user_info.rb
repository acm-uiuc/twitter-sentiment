require 'purdy-print'
require 'twitter-sentiment/parser/face_recon'
require 'twitter-sentiment/parser/text_mood'

module TwitterSentiment
  module Parser
    class UserInfo
        def initialize
            pp :info, "User info parser initialized successfully."
            @textmood = TwitterSentiment::Parser::TextMood.new :afinn
            @facerecon = TwitterSentiment::Parser::FaceRecon.new
        end

        #@param [Twitter::User] the user in question
    	#@return data about the user
    	def gather user
    		#Call all of the included methods
            if user != nil
        		boringImages = default_imgs(user.profile_background_image_url, user.profile_image_url) #int
        		followPerTweet = user.followers_count.to_f / user.statuses_count.to_f #float, 0...
        		profHappiness = @facerecon.profile_image_happiness(user.profile_image_url) #int, -100...100
        		descriptionScore = @textmood.score(user.description) #int

        		#Spit out data in some format
                return [boringImages, followPerTweet, profHappiness, descriptionScore]
            end
            return [0,0,0,0] if user == nil
    	end

    	#@param [String] Image url of user background image
    	#@param [String] Image url of user profile image
    	#@return [int] number of images that are default
    	def default_imgs back = nil, prof = nil
    		r = 0
    		r += 1 if back.index("twimg.com/images/themes/") != nil
    		r += 1 if prof.index("twimg.com/sticky/default_profile_images/") != nil
    		return r
    	end
    end #UserInfo
  end #Parser
end #TwitterSentiment
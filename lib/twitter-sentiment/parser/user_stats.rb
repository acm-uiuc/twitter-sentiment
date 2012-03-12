require 'purdy-print'
require 'twitter-sentiment/parser/face_recon'
require 'twitter-sentiment/parser/text_mood'

module TwitterSentiment
  module Parser
    class UserStats
        def initialize textmood=nil
            pp :info, "User info parser initialized successfully.", :high
            @textmood = textmood.nil? ? TwitterSentiment::Parser::TextMood.new(:afinn_emo) : textmood
        end

        def generate_score results
            sum = results.values.reduce(:+)
            sum.to_f/results.length
        end

        #@param [Twitter::User] the user in question
        #@return data about the user
        def gather status
            user = status.user
            #Call all of the included methods
            return nil if user.nil?
            boringImages = default_imgs(user.profile_background_image_url, user.profile_image_url) #int
            followPerTweet = user.followers_count.to_f / user.statuses_count.to_f #float, 0...
            descriptionScore = @textmood.score(user.description) #int

            #Spit out data in some format
            results = {
                :boring_images => boringImages * 5,
                :follows_per_tweet => followPerTweet * 10.0,
                :description_score => descriptionScore
            }
            results[:score] = generate_score results
            return results
        end
    end #UserInfo
  end #Parser
end #TwitterSentiment
require 'purdy-print'
require 'twitter-sentiment/parser/face_recon'
require 'twitter-sentiment/parser/text_mood'
Infinity = 1.0/0
module TwitterSentiment
  module Parser
    class UserStalker
        def initialize textmood=nil
            pp :info, "User stalker initialized successfully.", :high
            @timeline = TwitterSentiment::Input::TwitterTimeline.new
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

            tweets = @timeline.for_user user
            return nil if tweets.nil?
            sum = 0
            min = Infinity
            max = -Infinity
            tweets.each do |tweet|
                score = @textmood.score tweet.text
                sum += score
                min = score < min ? score : min
                max = score > max ? score : max
            end

            pp :debug, "#{tweets.length} tweets parsed in the timeline.", :high
            #Spit out data in some format
            return {
                :tweets => tweets.length,
                :sum    => sum,
                :min    => min,
                :max    => max,
                :score  => sum.to_f / tweets.length
            }
        end
    end #UserStalker
  end #Parser
end #TwitterSentiment
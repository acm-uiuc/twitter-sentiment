require 'rubygems'
require 'tweetstream'
require 'twitter_sentiment/prefs'
require 'twitter_sentiment/prefs/secrets'
module TwitterSentiment
	module Input
	    class Twitter
	        def initialize
	            stream_client = TweetStream::Client.new(TwitterSentiment::Prefs::Secrets.twitter)
			    stream_client.follow() do |status|
			        puts "[#{status.user.screen_name}] #{status.text}"
			    end
			end
		end # Twitter
	end # Input
end # TwitterSentiment
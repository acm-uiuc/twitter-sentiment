require 'rubygems'
require 'tweetstream'
require 'twitter_sentiment/prefs'
require 'twitter_sentiment/prefs/secrets'
module TwitterSentiment
	module Input
	    class Twitter
	        def initialize
	        	default = TwitterSentiment::Pref::Default.twitter
	            @client = TweetStream::Client.new(TwitterSentiment::Pref::Secret.twitter)

	            # Chain of fools
	            @client.on_delete { |status_id, user_id|
	            	#TODO: be nice and delete, or be a biznatch?
	            }.on_limit { |skip_count|
	            	#TODO: something
	            }.on_reconnect { |timeout, retries|
	            	#TODO: anything necessary? doubt it.
	            }

	            # Currently will track all references to default specified username.
			    @client.track("@#{default[:user_name]}") do |status|
			        puts "[#{status.user.screen_name}] #{status.text}"
			    end
			end
		end # Twitter
	end # Input
end # TwitterSentiment
require 'rubygems'
require 'twitter'
require 'purdy-print'
require 'paint'
require 'fiber'
require 'twitter-sentiment/prefs/defaults'
require 'twitter-sentiment/prefs/secrets'
module TwitterSentiment
    module Input
        include PurdyPrint
        class TwitterTimeline
            def initialize
                Twitter.configure do |config|
                    config = TwitterSentiment::Prefs::Secrets.twitter
                end
            end

            def for_user user
                tweets = []
                page = 0
                while not (page = Twitter.user_timeline(user, {:count => 200, :page => page})).empty?
                    tweets += page
                end
                return tweets
            rescue Exception => e
                puts e.message
                return tweets
            end
        end # TwitterTimeline
    end # Input
end # twitter-sentiment
require 'rubygems'
require 'tweetstream'
require 'purdy-print'
require 'paint'
require 'fiber'
require 'twitter-sentiment/prefs/defaults'
require 'twitter-sentiment/prefs/secrets'
module TwitterSentiment
    module Input
        include PurdyPrint
        class Twitter
            def initialize options
                default = TwitterSentiment::Prefs::Defaults.twitter
                @client = TweetStream::Client.new(TwitterSentiment::Prefs::Secrets.twitter)
                @fibers = [Fiber.current]
                # Chain of fools
                @client.on_delete { |status_id, user_id|
                    #TODO: be nice and delete, or be a biznatch?
                }.on_limit { |skip_count|
                    #TODO: something
                }.on_reconnect { |timeout, retries|
                    #TODO: anything necessary? doubt it.
                }

                # Currently will track all references to default specified username.
                #@client.track("@#{default[:user_name]}") do |status|
                #    puts "[#{status.user.screen_name}] #{status.text}"
                #end
                begin
                    @client.track(default[:search_phrase]) do |status|
                        begin
                            # raw debug tweet output
                            pp :debug, "#{Paint['['+status.user.screen_name+']', :yellow]} #{status.text}", :high
                            @fibers << Thread.new do
                                # call the status-received callback
                                options[:status_callback].call(status)
                            end
                            @fibers.last.run
                        rescue Interrupt
                            raise
                        rescue Exception => e
                            pp_exception e
                        end
                    end
                rescue EventMachine::ConnectionError => e
                    pp :error, "Couldn't connect to Twitter."
                end
            end
        end # Twitter
    end # Input
end # twitter-sentiment
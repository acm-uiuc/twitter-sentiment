require 'rubygems'
require 'tweetstream'
#require 'sigmusic/prefs/defaults'
#require 'sigmusic/prefs/secrets'

poo = TweetStream::Client.new()
poo.follow(480959867) do |status|
    puts "[#{status.user.screen_name}] #{status.text}"
end
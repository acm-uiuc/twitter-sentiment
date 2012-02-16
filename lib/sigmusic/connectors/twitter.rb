require 'rubygems'
require 'tweetstream'
#require 'sigmusic/prefs/defaults'
#require 'sigmusic/prefs/secrets'

poo = TweetStream::Client.new(
    :consumer_key       => 'xW42O1MOwxqqFdq7BxqSg',
    :consumer_secret    => 'UcBrgpAYiikKIVJw9Rkog0QK2EzJdVcselCbC8HAVmQ',
    :oauth_token        => '92918151-Bb5J5q0l9o14vxcLLvUwZwPqra4FKxFUpqE08aNUo',
    :oauth_token_secret => 'cUQtc5NnfwKdSHFJGDX2hog6EijdL1zgQuHioAElY')
poo.follow(480959867) do |status|
    puts "[#{status.user.screen_name}] #{status.text}"
end
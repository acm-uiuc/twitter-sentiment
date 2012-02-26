# Add lib/ folder to end of the Ruby library search path so we can simply require them like gems
$:.push File.join(File.dirname(__FILE__),'lib')

require 'paint'
require 'twitter-sentiment'

DEBUG = true
def pp mood=:info, msg=""
    moods = {
        :info => Paint["[info] ", [50,50,50]],
        :debug => Paint["[dbug] ", [87,14,88]],
        :warn  => Paint["[warn] ", [255,197,44]],
        :error => Paint["[erro] ", [254,0,106]],
        :happy => Paint["[ :) ] ", [151,192,12]],
        :sad   => Paint["[ :( ] ", [171,7,97]]
    }
    puts moods[mood] + msg
end

TwitterSentiment::Input::Twitter.new
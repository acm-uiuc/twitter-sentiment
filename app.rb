# Add lib/ folder to end of the Ruby library search path so we can simply require them like gems
$:.push File.join(File.dirname(__FILE__),'lib')
require 'rubygems'
require 'purdy-print'
require 'twitter-sentiment'
include PurdyPrint

class TwitterBeats
    @@debug = :high # PurdyPrint debug var

    def initialize
        pp :info, "TwitterBeats initializing..."
        textmood = TwitterSentiment::Parser::TextMood.new :afinn
        facerecon = TwitterSentiment::Parser::FaceRecon.new
        TwitterSentiment::Input::Twitter.new({
            :status_callback => lambda { |status|
                                    # text weight
                                    weight[:text] = textmood.score(status.text)
                                    mood[:text] = :bhargav
                                    mood[:text] = :happy if weight[:text] > 0
                                    mood[:text] = :sad if weight[:text] < 0
                                    pp mood[:text], "text score: #{weight[:text].to_s.ljust(7)}tweet: #{status.text}", :med
                                    # image weight
                                    weight[:img] = facerecon.profileImageHappiness(status.user.profile_image_url)
                                    pp :info, "face image weight received", :high
                                    mood[:img] = :bhargav
                                    mood[:img] = :happy if weight[:img] > 0
                                    mood[:img] = :sad if weight[:img] < 0
                                    pp mood[:img], "img score: #{weight[:img].to_s.ljust(8)}url: #{imgURL}", :med
                                },
        })
    end
end

# rile the beast
TwitterBeats.new
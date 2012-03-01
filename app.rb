# Add lib/ folder to end of the Ruby library search path so we can simply require them like gems
$:.push File.join(File.dirname(__FILE__),'lib')

require 'purdy_print'
require 'twitter-sentiment'
include PurdyPrint

class TwitterBeats
    @@debug = :high # PurdyPrint debug var

    def initialize
        pp :info, "TwitterBeats initializing...", :med
        textmood = TwitterSentiment::Parser::TextMood.new :afinn
        TwitterSentiment::Input::Twitter.new({
            :status_callback => lambda { |status|
                                    weight = textmood.score status.text
                                    mood = :bhargav
                                    mood = :happy if weight > 0
                                    mood = :sad if weight < 0
                                    pp mood, "score: #{weight.to_s.ljust(8)}tweet: #{status.text}"
                                    imgURL = status.user.profile_image_url
                                    imgWeight = TwitterSentiment::Parser::FaceRecon.profileImageHappiness imgURL
                                    imgmood = :bhargav
                                    imgmood = :happy if imgWeight > 0
                                    imgmood = :sad if imgWeight < 0
                                    pp imgmood, "imgscore: #{imgmood.to_s.ljust(8)}url: #{imgURL}"
                                },
        })
    end
end

# rile the beast
TwitterBeats.new
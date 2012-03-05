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
        userinfo = TwitterSentiment::Parser::UserInfo.new
        TwitterSentiment::Input::Twitter.new({
            :status_callback => lambda { |status|
                                    weight, mood = {}, {}
                                    pp :info, "NEW TWEET"
                                    # text weight
                                    weight[:text] = textmood.score(status.text)
                                    mood[:text] = :bhargav
                                    mood[:text] = :happy if weight[:text] > 0
                                    mood[:text] = :sad if weight[:text] < 0
                                    pp mood[:text], "text score: #{weight[:text].to_s.ljust(7)}tweet: #{status.text}", :med
                                    # image weight
                                    weight[:img] = facerecon.profile_image_happiness(status.user.profile_image_url)
                                    pp :info, "face image weight received", :high
                                    mood[:img] = :bhargav
                                    mood[:img] = :happy if weight[:img] > 0
                                    mood[:img] = :sad if weight[:img] < 0
                                    pp mood[:img], "img score: #{weight[:img].to_s.ljust(8)}url: #{status.user.profile_image_url}", :med
                                    #user stalking
                                    info = userinfo.gather(status.user)
                                    pp :info, "Boring images: #{info[0]}"
                                    pp :info, "Followers per tweet: #{info[1]}"
                                    mood[:description] = :bhargav
                                    mood[:description] = :happy if info[3] > 0
                                    mood[:description] = :sad if info[3] < 0
                                    pp mood[:description], "Description score: #{info[3]}; User description: #{status.user.description}"
                                },
        })
    end
end

begin
    # rile the beast
    TwitterBeats.new
rescue SystemExit, Interrupt
    pp :warn, "Interrupt received, quitting..."
    exit
end
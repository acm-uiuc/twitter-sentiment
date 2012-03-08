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
        output_send = TwitterSentiment::Output::Send.new
        TwitterSentiment::Input::Twitter.new({
            :status_callback => lambda { |status|
                                    weight, mood = {}, {}
                                    # text weight
                                    pp :seperator
                                    weight[:text] = textmood.score(status.text)
                                    mood[:text] = :bhargav
                                    mood[:text] = :happy if weight[:text] > 0
                                    mood[:text] = :sad if weight[:text] < 0
                                    pp mood[:text], "text score: #{weight[:text].to_s.ljust(7)}tweet: #{status.text}", :med
                                    # image weight
                                    imgurl = status.user.profile_image_url.gsub(/_normal/, '')
                                    begin
                                        weight[:img] = facerecon.profile_image_happiness(imgurl)
                                        pp :info, "face image weight received", :high
                                        mood[:img] = :bhargav
                                        mood[:img] = :happy if weight[:img] > 0
                                        mood[:img] = :sad if weight[:img] < 0
                                        pp mood[:img], "img score: #{weight[:img].to_s.ljust(8)}url: #{imgurl}", :med
                                    rescue
                                        pp :warn, "failed to download profile image, so cannot calculate face weight"
                                        mood[:img] = 0.0
                                    end
                                    #user stalking
                                    info = userinfo.gather(status.user)
                                    pp :info, "Boring images: #{info[0]}"
                                    pp :info, "Followers per tweet: #{info[1]}"
                                    weight[:description] = info[3]
                                    mood[:description] = :bhargav
                                    mood[:description] = :happy if weight[:description] > 0
                                    mood[:description] = :sad if weight[:description] < 0
                                    pp mood[:description], "Desc. score: #{weight[:description].to_s.ljust(8)}User description: #{status.user.description}"

                                    #compile data (not JSON)
                                    #put this is a separate method?
                                    total_happiness = Integer(weight[:text]) + Integer(weight[:img])/10 + Integer(weight[:description])
                                    capped_total_happiness = total_happiness
                                    capped_total_happiness = 10 if total_happiness > 10
                                    capped_total_happiness = -10 if total_happiness < -10

                                    total_excitement = Integer(info[1]*10) - Integer(info[0]*5)
                                    capped_total_excitement = total_excitement
                                    capped_total_excitement = 10 if total_excitement > 10
                                    capped_total_excitement = -10 if total_excitement < -10
                                    data = {
                                            "input" => {
                                                "source" => "twitter",
                                                "username" => status.user.screen_name,
                                                "displayname" => status.user.name,
                                                "userid" => status.user.id_str,
                                                "url" => "https://twitter.com/#!/" + status.user.screen_name + "/status/" + status.id_str + "/",
                                                "userimgurl" => imgurl,
                                                "raw_input" => status.text,
                                                "text" => nil,    #fix this
                                                "metadata" => nil #fix this
                                            }, #input
                                            "weights" => {
                                                "happiness" => capped_total_happiness, #filler algorithm
                                                "excitement" => capped_total_excitement, #filler algorithm
                                                "randomness" => rand(20) - 10 #literally random
                                            }, #weights
                                            "sentiment" => {
                                                "text" => {
                                                    "total_score" => total_happiness, #stolen from "happiness"
                                                    "positive_score" => nil, #fix this
                                                    "negative_score" => nil  #fix this
                                                },
                                                "tweet" => {
                                                    "hash_obnoxiousess" => status.entities.hashtags.length, #fix this
                                                    "retweet" => status.retweeted
                                                },
                                                "face" => {
                                                    "smiling" => nil,
                                                    "confidence" => nil,
                                                }
                                            } #sentiment
                                        } #data
                                    pp :info, "#{data}"
                                    output_send.send_gen data
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
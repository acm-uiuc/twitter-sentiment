# Add lib/ folder to end of the Ruby library search path so we can simply require them like gems
$:.push File.join(File.dirname(__FILE__),'lib')
require 'rubygems'
require 'bundler/setup'
require 'purdy-print'
require 'twitter-sentiment'
include PurdyPrint

class TwitterBeats
    @@debug = :high # PurdyPrint debug var



    def initialize
        pp :info, "TwitterBeats initializing..."
        textmood = TwitterSentiment::Parser::TextMood.new :afinn
        userinfo = TwitterSentiment::Parser::UserInfo.new
        output_send = TwitterSentiment::Output::Send.new
        random = TwitterSentiment::Parser::Randomness.new
        TwitterSentiment::Input::Twitter.new({
            :status_callback => lambda { |status|
                                    weight, mood = {}, {}
                                    pp :seperator
                                    # text weight
                                    text_score = textmood.score(status.text)
                                    weight[:text] = text_score[:score]
                                    mood  [:text] = mood_from_score weight[:text]
                                    pp mood[:text], "text score: #{weight[:text].to_s.ljust(7)}tweet: #{status.text}", :med

                                    #user stalking
                                    info = userinfo.gather(status.user)
                                    pp :info, "Boring images: #{info[0]}"
                                    pp :info, "Followers per tweet: #{info[1]}"
                                    weight[:description] = info[3][:score]
                                    weight[:img] = info[2]
                                    mood[:description] = mood_from_score weight[:description]
                                    mood[:img] = mood_from_score weight[:img]
                                    pp mood[:description], "Desc. score: #{weight[:description].to_s.ljust(8)}User description: #{status.user.description}"

                                    #symbol checking
                                    syms = random.symbol_count(status.text)
                                    pp :info, "syms: #{syms}"

                                    #compile data (not JSON)
                                    #put this is a separate method?
                                    total_happiness = Integer(weight[:text]) + Integer(weight[:img])/10 + Integer(weight[:description]) #textmood + imgscore/10 + userdescription
                                    capped_total_happiness = total_happiness
                                    capped_total_happiness = 10 if total_happiness > 10
                                    capped_total_happiness = -10 if total_happiness < -10

                                    total_excitement = Integer(info[1]*10) - Integer(info[0]*5) #followerspertweet * 10 - boringimages * 5
                                    capped_total_excitement = total_excitement
                                    capped_total_excitement = 10 if total_excitement > 10
                                    capped_total_excitement = -10 if total_excitement < -10

                                    total_randomness = -10 + Integer(syms[1]) + rand(5) #-10 + '?' + rand(5)
                                    capped_total_randomness = total_randomness
                                    capped_total_randomness = 10 if total_excitement > 10
                                    capped_total_randomness = -10 if total_excitement < -10
                                    data = {
                                            "input" => {
                                                "source" => "twitter",
                                                "username" => status.user.screen_name,
                                                "displayname" => status.user.name,
                                                "userid" => status.user.id_str,
                                                "url" => "https://twitter.com/#!/" + status.user.screen_name + "/status/" + status.id_str + "/",
                                                "userimgurl" => status.user.profile_image_url.gsub(/_normal/, ''),
                                                "raw_input" => status.text,
                                                "text" => text_score[:stripped_text],
                                                "metadata" => nil #fix this
                                            }, #input
                                            "weights" => {
                                                "happiness" => capped_total_happiness, #filler algorithm
                                                "excitement" => capped_total_excitement, #filler algorithm
                                                "randomness" => capped_total_randomness #literally random
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
                                    pp :info, "#{data}", :high
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
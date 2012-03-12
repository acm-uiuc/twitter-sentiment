# Add lib/ folder to end of the Ruby library search path so we can simply require them like gems
$:.push File.join(File.dirname(__FILE__),'lib')
require 'rubygems'
require 'bundler/setup'
require 'purdy-print'
require 'twitter-sentiment'
include PurdyPrint # colorful stylized console log library

stdout_mutex = Mutex.new

class TwitterBeats
    @@debug = :med # PurdyPrint debug var
    @@score_bounds = [-10,10]
    attr_reader :parsers

    def limit_score score
        return 0 if score.nil?
        score = score > @@score_bounds[1] ? @@score_bounds[1] : score
        score = score < @@score_bounds[0] ? @@score_bounds[0] : score
        return score.round
    end

    def happiness

        return limit_score(@parsers[:text_mood][:result][:score]*0.7+@parsers[:user_image][:result][:score]*0.2+@parsers[:user_stats][:result][:description_score]*0.1) \
            unless @parsers[:text_mood][:result][:score].nil? \
                or @parsers[:user_image][:result][:score].nil? \
                or @parsers[:user_stats][:result][:description_score].nil?

        return limit_score(@parsers[:text_mood][:result][:score]*0.8+@parsers[:user_image][:result][:score]*0.2) \
            unless @parsers[:text_mood][:result][:score].nil? \
                or @parsers[:user_image][:result][:score].nil?

        return limit_score(@parsers[:text_mood][:result][:score]*0.9+@parsers[:user_stats][:result][:description_score]*0.1) \
            unless @parsers[:text_mood][:result][:score].nil? \
                or @parsers[:user_stats][:result][:description_score].nil?

        return limit_score(@parsers[:text_mood][:result][:score]) \
            unless @parsers[:text_mood][:result][:score].nil?

        return 0
    end

    def paint_score num
        return Paint["nil", :italic, :yellow] if num.nil?
        return Paint[num.to_s, :bold, :red] if num < 0
        return Paint[num.to_s, :bold, :green] if num > 0
        return Paint[num.to_s, :bold]
    end

    def initialize
        pp :category, Paint["Welcome to ", :bold] + Paint["Twitter",:bright,:red] + Paint["Beats",:bright,:blue]
        # Since UserStats and TextMood can both use the same TextMood instance, we can send it the same
        # one and avoid double the generation.
        textmood_global = TwitterSentiment::Parser::TextMood.new(:afinn_emo)
        @parsers = {
            :text_mood  => { :instance => textmood_global },
            :user_image => { :instance => TwitterSentiment::Parser::FaceRecon.new },
            :user_stats => { :instance => textmood_global },
            :randomness => { :instance => TwitterSentiment::Parser::Randomness.new },
        }

        out = TwitterSentiment::Output::Send.new

        TwitterSentiment::Input::Twitter.new({
            :status_callback => lambda { |status|
                stdout = []
                stdout << fmt(:separator) # separate initialization text from tweet fun
                # text weight
                stdout << fmt(:info, "#{Paint["TWEET - ",:yellow]}#{status.text}")
                @parsers.each do |parser, c|
                    c[:result] = c[:instance].gather(status)
                                           #TWEET - #
                    stdout << fmt(c[:result][:score], "      #{Paint["|",:yellow]} #{paint_score(c[:result][:score].round(2))} #{Paint["<-",[50,50,50]]} #{parser.to_s}", :med)
                end

                weights = {
                    # happiness = 70% tweet, 20% image, 10% description
                    :happiness => happiness,
                    # excitement = follows per tweet
                    # TODO: make this actually excitement of post
                    :excitement => limit_score(@parsers[:user_stats][:result][:follows_per_tweet]),
                    # confusion = number of question marks and a hint of randomness
                    :randomness => limit_score(@parsers[:randomness][:result][:questions] + rand(5) * 2),
                }

                stdout << fmt(weights[:happiness], "h/e/c = #{weights[:happiness]}/#{weights[:excitement]}/#{weights[:randomness]}", :med)
                puts stdout.join("\n") # mutex-free debug outputs
                out.send_gen weights, status, parsers
            },
        })
    end
end

if __FILE__ == $0
    begin
        # rile the beast
        TwitterBeats.new
    rescue SystemExit, Interrupt
        pp :warn, "Interrupt received, quitting..."
        exit
    end
end
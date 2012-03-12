require 'yajl'
require 'socket'
require 'rubygems'
require 'purdy-print'
include PurdyPrint

module TwitterSentiment
    module Output
        include PurdyPrint
        class Send
            def initialize
                pp :info, "Send module initialized successfully."
            end

            # Sends data to the music generator
            # @param [Array] Data in pre-defined form (not in JSON)
            # @return [nil]
            def send_gen weights, status, parsers
                data = {
                    :input => {
                        :source => "twitter",
                        :username => status.user.screen_name,
                        :displayname => status.user.name,
                        :userid => status.user.id_str,
                        :url => "https://twitter.com/#!/" + status.user.screen_name + "/status/" + status.id_str + "/",
                        :userimgurl => status.user.profile_image_url.gsub(/_normal/, ''),
                        :raw_input => status.text,
                        :text => text_score[:stripped_text],
                        :metadata => nil #fix this
                    }, #input
                    :weights => weights, #weights
                    :sentiment => {
                        :text => {
                            :total_score => h, #stolen from "happiness"
                            :positive_score => nil, #fix this
                            :negative_score => nil  #fix this
                        },
                        :tweet => {
                            :hash_obnoxiousess => status.entities.hashtags.length, #fix this
                            :retweet => status.retweeted
                        },
                        :face => {
                            :smiling => nil,
                            :confidence => nil,
                        }
                    } #sentiment
                } #data
                payload = Yajl::Encoder.encode(data)
                streamSock = TCPSocket.new( "127.0.0.1", 9133 )
                streamSock.write(payload)
                streamSock.close
            rescue Exception
                pp :warn, "Failed to send payload across socket.", :low
            end
        end #Send
    end #Output
end #TwitterSentiment
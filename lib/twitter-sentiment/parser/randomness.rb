require 'purdy-print'
include PurdyPrint

module TwitterSentiment
    module Parser
        include PurdyPrint
        class Randomness
            def initialize
                #no code
            end

            #@param [String] Sentence (tweet)
            #@return [Array] ["!", "?", "/"]
            def symbol_count text
                # all lowercase, baby
                sentence = text.downcase
                chars = sentence.split(//) # break up into char array
                chars.reject! { |c| (c.>=('a') && c.<=('z')) || (c.>=('0') && c.<=('9')) || c.==(' ')} # get rid of any blank entries
                pp :info, "Punctuation detected: #{chars}", :high
                arr = {:exclamations => 0, :questions => 0, :slashes => 0}
                chars.each do |c|
                    arr[:exclamations] += 1 if c.==('!')
                    arr[:questions] += 1 if c.==('?')
                    arr[:slashes] += 1 if c.==('/')
                end
                arr
            end #symbol_count

            def gather status
                result = symbol_count status.text
                result[:score] = [[(result.values.reduce(:+).to_f/status.text.length)*10,10].min,-10].max
                return result
            end
        end #class
    end #Parser
end #TwitterSentiment
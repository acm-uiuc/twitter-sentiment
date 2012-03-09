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
        		pp :info, "Punctuation: #{chars}"
        		arr = [0,0,0]
        		chars.each do |c|
        			arr[0] += 1 if c.==('!')
        			arr[1] += 1 if c.==('?')
        			arr[2] += 1 if c.==('/')
        		end
        		arr
			end #symbol_count
		end #class
	end #Parser
end #TwitterSentiment
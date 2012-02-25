module TwitterSentiment
  module Parser
    # Analyzes text from a bag of words with sentiments attached (separated by white space)
    # See the dict/ folder for examples of bags.
    class TextMood

      @@bags_dir = 'dict' # What folder the dictionaries are stored in in project dir
      @@bags = {
        :afinn      => "AFINN-111-emo.txt",
        :afinn_emo  => "AFINN-111.txt",
      }
      #end

      # Load a file to be used as our bag of words.
      #
      # @param [String, Symbol] String path or symbol to a known dictionary we want to use
      # => Note: If it's a string, it's the path relative to the root directory.
      # @raise [ArgumentError] if the file isn't a word, a tab, and a score per line
      def initialize file
        case file
        when Symbol
          file = @@bags[file] # Convert from symbol to filepath if passed
        when String
          # Do nuttin', we already have a filepath
        else
          raise ArgumentError, "Expected String or Symbol input for file"
        end
        @dict = {}
        generate_dictionary File.open(File.join(@@bags_dir, file), "r")
      end

      # Generate Dictionary from file of proper syntax
      #
      # @param [File] file the file whose tab-separated word and score
      # @private
      def generate_dictionary file
        file.each_line do |line|
          line = line.strip.split("\t") # Strip newline, and turn into tab-separated array
          raise SyntaxError, "lines must be word{tab}weight" unless line.length == 2

          # word -> symbol for hash key, weight -> int value for hash value
          word, val = line[0].to_sym, line[1].to_i
          @dict[word] = val
        end
      end
      private :generate_dictionary

      # Returns the mood score of the string
      #
      # @param [String] word to search for
      # @return [Integer,nil] the 
      def score word
        return @dict[word] if @dict.member? word
        return nil
      end

    end # TextMood
  end # Parser
end # TwitterSentiment
require 'progressbar'
require 'linguistics'
include Linguistics::EN

module TwitterSentiment
  module Parser
    # Analyzes text from a bag of words with sentiments attached (separated by white space)
    # See the dict/ folder for examples of bags.
    class TextMood
      attr_reader :dict

      @@bags_dir = 'dict' # What folder the dictionaries are stored in in project dir
      @@bags = {
        :afinn_emo  => "AFINN-111-emo.txt",
        :afinn      => "AFINN-111.txt",
      }
      #end

      def symbolize string
        string.gsub(/\s+/, "_").downcase.to_sym
      end
      private :symbolize

      def desymbolize sym
        sym.to_s.gsub(/_/," ")
      end
      private :desymbolize

      # Load a file to be used as our bag of words.
      #
      # @param [String, Symbol] String path or symbol to a known dictionary we want to use
      # => Note: If it's a string, it's the path relative to the root directory.
      # @raise [ArgumentError] if the file isn't a word, a tab, and a score per line
      def initialize file
        @dict = {}
        case file
        when Symbol
          file = File.join(@@bags_dir, @@bags[file]) # Convert from symbol to filepath if passed
        when String
          # Do nuttin', we already have a filepath
        else
          raise ArgumentError, "Expected String or Symbol input for file"
        end
        
        pp :category, "dictionaries"
        generate_dictionary File.open(file, "r")
        generate_plurals
        generate_opposites
      end

      # Generate Dictionary from file of proper syntax
      #
      # @param [File] file the file whose tab-separated word and score
      # @private
      def generate_dictionary file
        pb = ProgressBar.new "file dict", dict.length # steps
        pb.format = "     %-14s %3d%% %s %s"
        file.each_line do |line|
          line = line.strip.split("\t") # Strip newline, and turn into tab-separated array
          raise SyntaxError, "lines must be word{tab}weight" unless line.length == 2

          # word -> symbol for hash key, weight -> int value for hash value
          word, val = symbolize(line[0]), line[1].to_i
          @dict[word] = val
        end
        pb.finish
      end
      private :generate_dictionary

      # Generate the opposite "not" versions of words to allow for a bit of negation compensation.
      #
      # @private
      def generate_opposites
        pb = ProgressBar.new "opposite dict", dict.length # steps
        pb.format = "     %-14s %3d%% %s %s"
        notdict = {}
        @dict.each do |word, score|
          notdict[symbolize("not #{desymbolize(word)}")] = -score
        end
        @dict.merge!(notdict) {|key, oldval, newval| oldval } # collisions won't be overwritten
        pb.finish
      end
      private :generate_opposites
      
 
      def generate_plurals
        pb = ProgressBar.new "plural dict", dict.length # steps
        pb.format = "     %-14s %3d%% %s %s"
        plurals = {}
        @dict.each do |word, score|
          plurals[symbolize(plural(desymbolize(word)))] = score
          pb.inc
        end
        @dict.merge!(plurals) {|key,oldval,newval| oldval }
        pb.finish
      end
      private :generate_plurals

      # Turn a potentially poorly-formatted "tweet-like" message into an array of
      # words that would hopefully exist in a dictionary. This will never be perfect,
      # and may need more improvement still. Will have to test against real data.
      #
      # @param [String] sentence to be cleaned and arrayitized
      # @return [Array<String>] the array of words after being sanitized (to an extent)
      def sentence_to_stripped_array sentence
        # all lowercase, baby
        sentence = sentence.downcase
        # remove all http://URLs, #hashtags, @references, and 'quotation marks' from sentence
        TwitterSentiment::Prefs::Defaults.strip_regex.each_value do |rule|
          sentence.gsub!(rule[:regex], rule[:sub])
        end
        words = sentence.split(/[?!., ]/) # break up by spaces or punctuation
        words.reject! { |word| word.nil? or word.empty? } # get rid of any blank entries
        while not (i = words.index("not")).nil?
          words[i,2] = words[i,2].join(" ") unless i == words.length
        end
        return words
      end
      private :sentence_to_stripped_array

      # Returns the mood score of the string.
      #
      # @param [String] string to score
      # @return [Hash,nil] the score and stripped text string that was used for scoring
      def gather status
        text = status.text
        words = sentence_to_stripped_array text
        sentence_score = score text
        return {:score => ((sentence_score.to_f/words.length)*20), :stripped_text => words.join(" ")}
      end

      def score text
        words = sentence_to_stripped_array text
        total = 0
        words.each do |word|
          total += @dict[symbolize(word)] if @dict.member? symbolize(word)
        end
        return total
      end
    end # TextMood
  end # Parser
end # TwitterSentiment
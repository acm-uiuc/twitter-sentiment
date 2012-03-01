require 'face'
require 'twitter-sentiment/prefs/secrets'
require 'purdy-print'

module TwitterSentiment
  module Input
    include PurdyPrint
    class FaceRecon
      #JSON PARSING:
      #results["photos"][photo number]["tags"][face number]["attributes"]["smiling"]["value" or "confidence"]
      
      #Returns the client needed to make searches
      def initialize
        file = TwitterSentiment::Prefs::Secrets.face
        @client = Face.get_client(:api_key => file[:key], :api_secret => file[:secret])
        pp :info, "Face input initialized successfully."
      end
      
      #Returns Face API info (uses rest API)
      #@param [String] Image URL
      #@return [JSON]
      def detectFaces imgurl = ""
        return @client.faces_detect(:urls => [imgurl])
      end
    end #FaceRecon
  end #Input
end #TwitterSentiment
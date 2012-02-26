require 'face'
require 'twitter_sentiment/prefs'
require 'twitter_sentiment/prefs/secrets'

module TwitterSentiment
  module Parser
    class FaceRecon
      #JSON PARSING:
      #results["photos"][photo number]["tags"][face number]["attributes"]["smiling"]["value" or "confidence"]
      
      #Returns the client needed to make searchs
      #
      #@private
      def makeClient
        file = TwitterSentiment::Pref::Secrets.face
        Face.get_client(:api_key => file[:key], :api_secret => file[:secret])
      end
      private :makeClient
      
      #Returns an array (info about the first detected face)
      #
      #@param [String] Image url
      #@return [[boolean,int]] Smiling?, confidence
      def smileInfo imgurl = ""
        client = makeClient
        results = client.faces_detect(:urls => [imgurl])
        results = results["photos"][0]["tags"][0]["attributes"]["smiling"]
        [results["value"], results["confidence"]]
      end
    end #FaceRecon
  end #Parser
end #TwitterSentiment
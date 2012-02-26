require 'face'
require 'twitter-sentiment/prefs/secrets'

module TwitterSentiment
  module Input
    class Face
      #JSON PARSING:
      #results["photos"][photo number]["tags"][face number]["attributes"]["smiling"]["value" or "confidence"]
      
      #Returns the client needed to make searches
      #
      #@private
      def makeClient
        file = TwitterSentiment::Pref::Secrets.face
        Face.get_client(:api_key => file[:key], :api_secret => file[:secret])
      end
      private :makeClient
      
      #Returns Face API info (uses rest API)
      #@param [String] Image URL
      #@return [JSON]
      def detectFaces imgurl = ""
        client = makeClient
        return client.faces_detect(:urls => [imgurl])
      end
    end #Face
  end #Input
end #TwitterSentiment
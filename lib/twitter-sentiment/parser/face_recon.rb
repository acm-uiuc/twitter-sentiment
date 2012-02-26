require 'face'
module TwitterSentiment
  module Parser
    module FaceRecon
      #JSON PARSING:
      #results["photos"][photo number]["tags"][face number]["attributes"]["smiling"]["value" or "confidence"]
      
      #Returns the client needed to make searchs
      #Intended to be a private method
      def self.makeClient()
        #Gets API key and secret from file (lines 0 and 1)
        secretsfile = File.new("./scowalt-secrets.txt")
        secrets = secretsfile.readlines
        apikey = secrets[0][12..secrets[0].length-2]
        apisecret = secrets[1][12..secrets[1].length-1]
        Face.get_client(:api_key => apikey, :api_secret => apisecret)
      end
      
      #Returns an array (info about the first detected face): [boolean, integer]
      #Boolean: Smiling?
      #Integer: Confidence
      def self.smileInfo (imgurl = "")
        client = FaceRecon.makeClient()
        results = client.faces_detect(:urls => [imgurl])
        results = results["photos"][0]["tags"][0]["attributes"]["smiling"]
        [results["value"], results["confidence"]]
      end
    end #FaceRecon
  end #Parser
end #TwitterSentiment
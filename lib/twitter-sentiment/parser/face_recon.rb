module TwitterSentiment
  module Parser
    class FaceRecon
      #JSON PARSING:
      #results["photos"][photo number]["tags"][face number]["attributes"]["smiling"]["value" or "confidence"]
      
      #Returns an array of arrays (info about the detected faces)
      #
      #@param [FaceAPI search] Image info
      #@return [[boolean,int]...] Smiling?, confidence
      def smileInfo info = ""
        info = info["photos"][0]["tags"]
        arr = []
        info.each do |n|
          n = n["attributes"]["smiling"]
        end
        arr += [[n["value"],n["confidence"]]]
        arr
      end
    end #FaceRecon
  end #Parser
end #TwitterSentiment
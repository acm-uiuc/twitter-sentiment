require 'twitter-sentiment/input/face'

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
          arr += [[n["value"],n["confidence"]]]
        end
        arr
      end

      #Finds the average happiness of people in profile picture, 
      #weighted based on confience and number of faces
      #@param [String] imgURL
      #@return [float] average happiness
      def profileImageHappiness img = nil
        if img != nil
          arr = TwitterSentiment::Input::Face.detectFaces(img) #call whatever calls the FaceAPI
          arr = smileInfo(arr) #format the search results
          #expecting arr = [[boolean,int],[boolean,int].....]
          score = 0
          arr.each do |n|
            s = n[1]
            s *= -1 if !n[0]
            score += s
          end
          score.to_f / r.len.to_f
        end # if != nil
      end
    end #FaceRecon
  end #Parser
end #TwitterSentiment
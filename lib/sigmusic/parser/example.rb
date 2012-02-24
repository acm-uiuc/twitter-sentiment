require "./textmood"
require "./facerecon.rb"


string = "I love everything about everyting :)"
face = "http://fearlesscompetitor.com/site/wp-content/uploads/2011/07/george_clooney_smile.jpg"

puts "Text:"
print "Score for string \"", string, "\":\n"
puts TextMood.score(string), ""

puts "Image:"
puts "Is the face smiling?"
faceR = FaceRecon.smileInfo(face)
puts faceR[0]
puts "How sure?"
print faceR[1], "%", "\n"
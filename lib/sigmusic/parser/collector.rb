print "Loading Twitter\n"
require 'twitter'
print "Done!\n"
require "./textmood.rb"
require "./facerecon.rb"

#GOLBAL VARIABLES
phrase = "#WhyDoPeopleThink"
#END

#Accumulates info about the tweet and tweeter
def sendt(user = nil, image = nil, tweet = nil)
  #print "Found tweet!\nGathering info\n"
  #uI = userInfo(user)
  #iA = imageAnalysis(image)
  tM = TextMood.score(tweet)
  print "Score: ", score, "\n"
  #cS = calmScore(tweet)
  #arr = userInfo(user) + imageAnalysis(image) + [tweetMood(tweet)]
  #sendData(arr)
  #sendUI(user,image,tweet)
end

#Sends array data to the PD core
def sendData(intArr = [nil])
  print "NYI sendData(" + intArr + ")\n"
end

#Sends tweet data to WebUI
def sendUI(user = nil, image = nil, tweet = nil)
  print "NYI sendUI\n"
end

#Returns an integer array containing data about the image
def imageAnalysis(image = nil)
  #TODO Find image analysis library
  print "NYI imageAnalysis\n"
end

#Returns an integer array containing data about the user
def userInfo(user = nil)
  #TODO Collect info on user
  print "NYI userInfo\n"
end

#Returns a score the represents the calm of a tweet
#Low score is calm, high score is excited
def calmScore(tweet = nil)
  #TODO
end

print "Beginning search loop\n"
str = phrase + " -rt"
latest = 0
t = Time.now.min*60 + Time.now.sec
loop = true
len = 0

print "Searching...\n"
arr = Twitter.search(str, :since_id => latest, :lang => "en", :rpp => 100)
#Constantly finds new tweets containing the search phrase
while loop
  tNew = Time.now.min*60 + Time.now.sec
  if (tNew > t+30) #only search every 30 seconds
    print "Searching...\n"
    arr = Twitter.search(str, :since_id => latest, :lang => "en", :rpp => 100)
    t = tNew
  else
    arr = []
  end
  len = arr.length
  print "Search found ", len," tweets.\n" if (len!=0)
  x=len-1 #reset counter
  while x>=0
    tweet = arr[x]
    if tweet.id > latest #not an old tweet
      #print "New tweet!\n"
      sendt(tweet.from_user, tweet.profile_image_url, tweet.text)
      latest = tweet.id
    end
    x=x-1
  end #array loop
end #search loop
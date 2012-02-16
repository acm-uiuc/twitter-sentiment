print "Loading Twitter\n"
require 'twitter'

print "Done!\n"

#GOLBAL VARIABLES
phrase = "#WhyDoPeopleThink"
#END

#Accumulates info about the tweet and tweeter
def sendt(user = nil, image = nil, tweet = nil)
  #print "Found tweet!\nGathering info\n"
  #uI = userInfo(user)
  #iA = imageAnalysis(image)
  tM = tweetMood(tweet)
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

#Returns an integer representation of the mood of a string of text
def tweetMood(tweet = nil)
  #TODO Account for punctuation after words
  print "Original tweet: " + tweet + "\n"

  file = File.new("AFINN-111.txt", "r")
  afinn = file.readlines() #string array
  score = 0

  tweetArr = textToArray(tweet)

  #Compares each word to the AFINN, tallies the  score
  length = tweetArr.length
  n = 0
  while (n<length)
    word = tweetArr[n]
    wordScore = Integer(searchScoreW(afinn,word))
    #print "Word: \"",word,"\", Score: ",wordScore,"\n"
    score += wordScore
    n += 1
  end
  print "Score = ", score, "\n"
  return score
end

#Takes a string and turns it into a string array
def textToArray (tweet)
  length = tweet.length()
    n = 0
    wordStart = 0
    tweetArr = []
    while (n < length)
      if(tweet[n] == ' ' || n == length - 1)
        if (n == length - 1) #fixes off by one at end
          n+=1
        end
        tweetArr += [tweet[wordStart..n-1]]
        wordStart = n+1
      end
      n+=1
    end
    tweetArr
end

#Returns the mood score of a given word (wrapper)
def searchScoreW(arr = nil, word = nil)
  if(word != nil && arr != nil)
    word.downcase!
    searchScore(arr,word,0,arr.length-1)
  end #word not nil
end #searchScore

#Returns the modd score of a given word (recursive binary search)
def searchScore(arr, word, lo, hi)
  return 0 if (hi<lo)
  mid = ((lo+hi)/2)
  #print "mid = ",mid,"\n"
  arrLine = arr[mid]
  stop = arrLine.index("\t")
  arrWord = arrLine[0..(stop-1)]
  if(arrWord.==(word))
    arrLine[stop+1..arrLine.length()-1]
  elsif(arrWord.<(word))
    searchScore(arr, word, mid+1, hi)
  elsif(arrWord.>(word))
    searchScore(arr, word, lo, mid-1)
  end
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
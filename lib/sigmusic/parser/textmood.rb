module TextMood
  #Module variables
  filestring = "AFINN-111-emo.txt"
  #end
  
  file = File.new(filestring)
  @fileArr = file.readlines()
  
  #Returns the mood score of the string
  def self.score(s = "")
    sArr = TextMood.textToArray(s)
    score = 0
    n = 0
    while n<sArr.length
      wordscore = TextMood.searchScoreW(sArr[n]) #string
      score += Integer(wordscore)
      n+=1
    end
    score
  end
  
  #Takes a string and turns it into a string array
  #TODO remove punctuation from words
  def self.textToArray (text)
    length = text.length()
      n = 0
      wordStart = 0
      textArr = []
      while (n < length)
        if(text[n] == ' ' || n == length - 1)
          if (n == length - 1) #fixes off by one at end
            n+=1
          end
          textArr += [text[wordStart..n-1]]
          wordStart = n+1
        end
        n+=1
      end
      textArr
  end
  
  #Returns the mood score of a given word (wrapper)
  def self.searchScoreW(word = nil)
    if(word != nil)
      word.downcase!
      TextMood.searchScore(@fileArr,word,0,@fileArr.length-1)
    end #word not nil
  end #searchScore

  #Returns the mood score of a given word (recursive binary search)
  def self.searchScore(arr, word, lo, hi)
    return 0 if (hi<lo)
    mid = ((lo+hi)/2)
    arrLine = arr[mid]
    stop = arrLine.index("\t")
    arrWord = arrLine[0..(stop-1)]
    if(arrWord.==(word))
      arrLine[stop+1..arrLine.length()-1]
    elsif(arrWord.<(word))
      TextMood.searchScore(arr, word, mid+1, hi)
    elsif(arrWord.>(word))
      TextMood.searchScore(arr, word, lo, mid-1)
    end
  end
end
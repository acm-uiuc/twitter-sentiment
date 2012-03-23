Twitter Sentiment
=================
Take a tweet, extract a *TON* of information out of a short bit of text.
Let's do this.

Get it running
------------------
### 1. Install RVM (if you have it already, skip to step 2)
######(from [beginrescueend.com](http://beginrescueend.com/))

```bash
bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)
source ~/.bash_profile
```

####Linux Users
```bash
rvm install 1.9.3
```

####Mac Users
[Install XCode from the App Store](http://itunes.apple.com/us/app/xcode/id497799835?mt=12) if you haven't already (it's free).

```bash
rvm install 1.9.3 --with-gcc=clang
```

OS X users may be interested in [Jewelry Box](http://unfiniti.com/software/mac/jewelrybox), a Cocoa UI for RVM.

####Windows users
Install Ruby from [RubyInstaller](http://rubyinstaller.org/downloads/)

The DevKit is also required to install some of the gems described below

### 2. Install the necessary gems
```bash    
gem install bundler
bundle install
```
    
### 3. Run it

```bash
bundle exec ./app.rb
```

Directory Structure
-------------------

`lib/` is where the bulk of the code lies. It is all of the library files used by our app.rb.

- `twitter-sentiment/`: libraries in our namespace.

	- `input/`: libraries that contact the outside world via APIs (generally).

	- `output/`: libraries that send data outward.
	
	- `parser/`: libraries that get data form inputs, parse them, and give weights to be aggregated.
	
	- `prefs/`: preferences and constants to be used by any of the aforementioned libraries/files.



`dict/` contains the collection of dictionaries (bag of words, or BoW) being used for sentiment analysis.

`research/` is a general placeholder for interesting papers and potential BoWs.
	

Research Leads
--------------
### AFINN
#### Descriptions
[AFINN: A new word list for sentiment analysis](http://fnielsen.posterous.com/afinn-a-new-word-list-for-sentiment-analysis)

[Simplest Sentiment Analysis in Python](http://fnielsen.posterous.com/simplest-sentiment-analysis-in-python-with-af)

#### Related
[Twitter Mood](http://www.ccs.neu.edu/home/amislove/twittermood/)

[ANEW Sentiment-Weighted Word Bank](http://csea.phhp.ufl.edu/media/anewmessage.html)

[Measuring User Influence in Twitter](http://an.kaist.ac.kr/~mycha/docs/icwsm2010_cha.pdf)

Projects/Papers
---------------

[Sentiment strength detection in short informal text](http://onlinelibrary.wiley.com/doi/10.1002/asi.21416/abstract)

[Twitter as a Corpus for Sentiment Analysis and Opinion Mining](http://deepthoughtinc.com/wp-content/uploads/2011/01/Twitter-as-a-Corpus-for-Sentiment-Analysis-and-Opinion-Mining.pdf)

[We Feel Fine](http://wefeelfine.org/faq.html)

Modeling Statistical Properties of Written Text (lookup!)

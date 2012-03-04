Twitter Sentiment
=================
Take a tweet, extract a *TON* of information out of a short bit of text.
Let's do this.

Start from scratch
------------------
### Install RVM (if you haven't already)
Follow the instructions at [beginrescueend.com](http://beginrescueend.com/). In short, install RVM:

	$ bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)
	$ source ~/.bash_profile

####Linux Users
	$ rvm install 1.9.3 
####Mac Users
Install XCode from the App Store if you haven't already (it's free).

	$ rvm install 1.9.3 --with-gcc=clang

OS X users may be interested in [Jewelry Box](http://unfiniti.com/software/mac/jewelrybox), a Cocoa UI for RVM.

### Install the necessary gems
######(don't worry, `#` is a legitimate bash/zsh comment so you can still copy-paste)

	gem install rake 			# Ruby Make - build tool
	gem install yard 			# YARDoc docuementation generator
	gem install yajl-ruby		# Fastest JSON parser this side of the atlantic
	gem install cucumber		# Cucumber BDD/TDD test suite
	gem install tweetstream		# Ruby wrapper for Twitter Streaming API
	gem install twitter			# Ruby wrapper for Twitter RESTful API
	gem install face			# Ruby wrapper for Face (recognition) API
	gem install paint			# Ruby pretty colorful console output
	gem install progressbar		# Ruby pretty console progress bars
	
We will move this to a RubyGem when development is further down the road to make these dependencies more easily fulfilled.

Directory Structure
-------------------
`dict/` contains the collection of dictionaries (bag of words, or BoW) being used for sentiment analysis.

`lib/` contains the generalized libraries used by our toolkit.

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

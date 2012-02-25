Twitter Sentiment
=================
We've all seen those interesting visualizations about twitter "moods." Most of them are not the most intelligent systems for detecting the really cool parts about posts. On top of that, nobody has invented a proper toolkit for analyzing, breaking up, and getting *as much* information about shorts snippets (or potentially long) as possible.

Let's do this.

Directory Structure
-------------------
`dict/` contains the collection of dictionaries (bag of words, or BoW) being used for sentiment analysis.

`lib/` contains the generalized libraries used by our toolkit.

`research/` is a general placeholder for interesting papers and potential BoWs.

Preparing your environment
--------------------------
The toolbox requires JRuby, as it interacts with Java libraries, which only the JRuby VM supports. It is highly recommended you use [RVM](http://beginrescueend.com/) to manage the various Ruby VMs. OS X users can use [Jewelry Box](http://unfiniti.com/software/mac/jewelrybox).

With RVM installed:

	rvm install jruby
	rvm use jruby
	gem install rake
	gem install yardoc
	gem install twitter
	gem install twitter-stream
	

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



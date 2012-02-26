$:.push File.join(File.dirname(__FILE__),'..','..','lib')
begin require 'rspec/expectations'; rescue LoadError; require 'spec/expectations'; end
require 'twitter-sentiment/parser/text_mood'

Before do
	@text_mood = nil
end

After do
end

Given /I start an instance initialized with '(.*)'/ do |file|
    file = file[1..-1].to_sym if file[0] == ":" # convert to symbol from string if that's what's passed
    begin
        @text_mood = TwitterSentiment::Parser::TextMood.new(file)
    rescue Exception => e
        @text_mood = Exception.new
    end
end

When /I ask the score of '(.*)'/ do |word|
    @result = @text_mood.score word
end

Then /the score returned should be '(.*)'/ do |result|
    result = result == 'nil' ? nil : result.to_f

    @result.should == result
end

Then /an exception should be thrown/ do
    @text_mood.is_a? Exception
end
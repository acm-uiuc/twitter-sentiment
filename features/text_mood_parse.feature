Feature: Text Mood Parsing
	In order to make sure the dictionary bag-of-words with weightings is parsed without mistakes
	I am going to pass in a known legal file and request it be parsed and report back a score

	Scenario: Initializing with a symbol
		Given TextMood is loaded successfully
		When I start an instance initialized with ':afinn'
		 And I ask the score of 'assfucking'
		Then the score returned should be '-4'

	Scenario: Initializing with a string
		Given TextMood is loaded successfully
		When I start an instance initialized with 'dict/AFINN-111.txt'
		 And I ask the score of 'assfucking'
		Then the score returned should be '-4'
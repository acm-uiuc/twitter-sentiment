Feature: Text Mood Parsing
	In order to make sure the dictionary bag-of-words with weightings is parsed without mistakes
	I am going to pass known and unknown file inputs and request it be parsed and report back a score

	Scenario: Initializing with a symbol
		Given I start an instance initialized with ':afinn'
		When I ask the score of 'assfucking'
		Then the score returned should be '-4'

	Scenario: Initializing with a legit filepath string
		Given I start an instance initialized with 'dict/AFINN-111.txt'
		When I ask the score of 'assfucking'
		Then the score returned should be '-4'

	Scenario: Initialize with a nonexistent filepath string
		Given I start an instance initialized with 'dict/thisnameshouldneverexist.diggisthebest.justkidding'
		Then an exception should be thrown

	Scenario: Initializing with a legit filepath string
		Given I start an instance initialized with 'dict/AFINN-111.txt'
		When I ask the score of 'darthvaderinaspeedo'
		Then the score returned should be 'nil'

Feature: Text Mood Dictionary Augmentation
	In order for the dictionary
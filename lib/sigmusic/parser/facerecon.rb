print "Starting program\n"
require 'face'

#GLOBAL VARIABLES
smileface = 'http://www.esquire.com/cm/esquire/images/FK/george-clooney-smile-WI-1009-lg.jpg'
frownface = 'http://1.bp.blogspot.com/_gjr6QvNeMBA/R1BPauUkFaI/AAAAAAAAAx8/MfNs5PV768Q/s1600-R/O%27Reilly+frown.bmp'
#END GLOBAL VARIABLES

#Gets API key and secret from file (lines 0 and 1)
secretsfile = File.new("scowalt-secrets.txt")
secrets = secretsfile.readlines
apikey = secrets[0][12..secrets[0].length-2]
apisecret = secrets[1][12..secrets[1].length-1]

#Gets sentiment information on the smileface and frownface
client = Face.get_client(:api_key => apikey, :api_secret => apisecret)
results = client.faces_detect(:urls => [smileface,frownface])
#results["photos"][photo number]["tags"][face number]["attributes"]["smiling"]["value" or "confidence"]

smileresults = results["photos"][0]
frownresults = results["photos"][1]

print "Smile face smiling? ", results["photos"][0]["tags"][0]["attributes"]["smiling"]["value"], "\n"
print "Smile face confidence: ", results["photos"][0]["tags"][0]["attributes"]["smiling"]["confidence"], "\n"
print "Frown face smiling? ", frownresults["tags"][0]["attributes"]["smiling"]["value"], "\n"
print "Frown face confience: ", frownresults["tags"][0]["attributes"]["smiling"]["confidence"], "\n"

#print results
print "\nDONE"
gets
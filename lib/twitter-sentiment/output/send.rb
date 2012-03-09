require 'json'
require 'socket'
require 'rubygems'
require 'json'
require 'purdy-print'
include PurdyPrint

module TwitterSentiment
	module Output
		include PurdyPrint
		class Send
			def initialize
				pp :info, "Send module initialized successfully."
			end

			# Sends data to the music generator
			# @param [Array] Data in pre-defined form (not in JSON)
			# @return [nil]
			def send_gen data = nil
				payload = data.to_json
				streamSock = TCPSocket.new( "127.0.0.1", 9133 )
				streamSock.write(payload)
				streamSock.close
			rescue Exception
				pp :warn, "Failed to send payload across socket."
			end
		end #Send
	end #Output
end #TwitterSentiment
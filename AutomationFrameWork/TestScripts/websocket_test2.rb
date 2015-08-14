require 'json'
require 'eventmachine'
require 'em-http-request'

# Use this script to make certain your dev/testing machine can open an encrypted websocket.

EventMachine.run {
  http = EventMachine::HttpRequest.new("wss://staging.collaboration.bluescape.com:443").get :timeout => 1
  
  http.errback { 
    puts "oops"
    puts http.error
  }
  
  http.callback {
    puts "Websocket connected!"
    
  }
  
  http.stream { |msg|
    puts "Received: #{msg}"
  }
}
require 'em-http-request'

EventMachine.run {
	http = EventMachine::HttpRequest.new(
		'https://www.53.com/wps/portal/personal')
	.get

	http.callback {
		puts http.response_header.status
		puts http.response_header
		puts http.response
		
		EventMachine.stop
	}	
}
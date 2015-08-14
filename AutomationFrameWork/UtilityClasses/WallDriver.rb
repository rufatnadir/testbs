require 'faye/websocket'
require 'eventmachine'

class WallDriver
  attr_accessor :input
  attr_reader :output
  attr_accessor :wall_address

  def initialize(wall_address)
    @input = [];
    @output = [];
    @wall_address = 'wss://' + wall_address;
    @ws = nil;
    @all_done = false
    
    #first item sent to the Wall is always the handshake message
    @input << '{"command":"handshake","clientName":"WallAutomationClient","secret":"FestiveP4nt4lones"}'
  end

  def open
    if @input.last != 'close'
      @input << 'close'
    end
    
    EventMachine.run {
      
      EventMachine.add_periodic_timer(1){ 
        if @all_done
          EventMachine.stop
        end
      }
      
      headers = {'Origin' => 'http://testing.bluescape.com'}
      @ws = Faye::WebSocket::Client.new(@wall_address, nil, :headers => headers)

      @ws.onopen = lambda do |event|
        #puts [:open, @ws.headers]

        unless @input.nil?
          @input.each do |msg|            
            if msg == 'close'
              @all_done = true
            else
              #puts msg
              @ws.send(msg)
            end
            
          end
        end
      end

      @ws.onclose = lambda do |close|
        if close.code != 1006  #1006 = normal close
          puts [:close, close.code, close.reason]
        end
        EventMachine.stop
      end

      @ws.onerror = lambda do |error|
        puts [:error, error.message]
      end

      @ws.onmessage = lambda do |message|
        #puts [:message, message.data]
        @output << message.data
      end
    }
  end
end


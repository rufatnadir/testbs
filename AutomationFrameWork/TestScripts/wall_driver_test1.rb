require 'faye/websocket'
require 'eventmachine'

class WallSocket
  attr_accessor :input
  attr_accessor :output
  #attr_reader :all_done

  def initialize
    @input = [];
    @output = [];
    @ws = nil;
    @all_done = false
    
  end

  def open
    if @input.last != 'close'
      @input << 'close'
    end
    
    EventMachine.run {
      
      EventMachine.add_periodic_timer(1){ 
        if @all_done
          EventMachine.stop
        else
          #puts 'not done yet'
        end
      }
      
      headers = {'Origin' => 'http://www.protiviti.com'}
      @ws = Faye::WebSocket::Client.new("wss://10.18.184.214:1024", nil, :headers => headers)

      @ws.onopen = lambda do |event|
        #puts [:open, @ws.headers]

        unless @input.nil?
          @input.each do |msg|            
            #unless msg == 'close'
            #msg = @input.shift
            #puts 'msg: ' + msg + "\n input queue length: " + @input.length
            
            #puts 'msg: ' + msg + ' all_done: ' + @all_done.to_s
            
            if msg == 'close'
              @all_done = true
            else
              @ws.send(msg)
            end
            
          end
          
          #EventMachine.stop
          
        end

        #ws.send(handshake)
        #ws.send(addNotecard)
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


walldriver = WallSocket.new
walldriver.input << '{"command":"handshake","clientName":"Dave","secret":"FestiveP4nt4lones"}'
walldriver.input << '{"command":"addNotecard","id":"DaveNoteCard1","args":{"templateIndex":"1","text":"Hello world!"}}'

#walldriver.input << 'close'
walldriver.open

puts 'output: ' + walldriver.output.to_s

#walldriver.close


require 'faye/websocket'
require 'eventmachine'

#  Trying to figure out the virtual touchpoint commands for pan, zoom, flick, etc.


handshake = '{"command":"handshake","clientName":"WebSocketTest1","secret":"FestiveP4nt4lones"}'

touchPointBegin = '{"command":"canvasTouchPointBegin","id":"1","args":{"id":"1","x":"2","y":"3"}}'
touchPointUpdate1 = '{"command":"canvasTouchPointUpdate","id":"1","args":{"id":"1","x":"20","y":"30"}}'
touchPointUpdate2 = '{"command":"canvasTouchPointUpdate","id":"1","args":{"id":"1","x":"-20","y":"-30"}}'

touchPointEnd = '{"command":"canvasTouchPointEnd","id":"1","args":{"id":"1"}}'

EventMachine.run {
  headers = {'Origin' => 'http://testing.bluescape.com'}
  ws = Faye::WebSocket::Client.new("wss://10.18.184.214:1024", nil, :headers => headers)

  ws.onopen = lambda do |event|
    puts [:open, ws.headers]

    ws.send(handshake)

    ws.send(touchPointBegin)
    
    ws.send(touchPointUpdate1)
    ws.send(touchPointUpdate2)
    
    ws.send(touchPointEnd)
  end

  ws.onclose = lambda do |close|
    puts [:close, close.code, close.reason]
    EventMachine.stop
  end

  ws.onerror = lambda do |error|
    puts [:error, error.message]
  end

  ws.onmessage = lambda do |message|
    puts [:message, message.data]
  end
}
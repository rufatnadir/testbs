require 'faye/websocket'
require 'eventmachine'

#  Use this script to quickly see if a Wall's remote control daemon is running
#  Make sure the Wall is inside a workspace and not in the lobby. Temp workspace is fine.

handshake = '{"command":"handshake","clientName":"WebSocketTest1","secret":"FestiveP4nt4lones"}'

addNotecard = '{"command":"addNotecard","id":"TestNoteCard1","args":{"templateIndex":"1","text":"Hello world!"}}'

EventMachine.run {
  headers = {'Origin' => 'http://testing.bluescape.com'}
  ws = Faye::WebSocket::Client.new("wss://10.18.184.214:1024", nil, :headers => headers)

  ws.onopen = lambda do |event|
    puts [:open, ws.headers]

    ws.send(handshake)

    ws.send(addNotecard)
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
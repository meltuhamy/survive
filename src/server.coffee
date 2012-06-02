io = require("socket.io")
express = require("express")
server = express.createServer()
server.use express.static(__dirname + "/public")
server.listen 8080
socket = io.listen(server)
socket.sockets.on "connection", (client) ->
  client.join('game')
  socketArray = []
  socket.sockets.clients('game').forEach( (thesocket) ->  socketArray.push thesocket)
  socket.sockets.in('game').emit('roommsg', socketArray.length)
  client.send "Your id is #{client.id}"
  interval = setInterval(->
    client.send "This is a message from the server!"
  , 10000)
  client.on "message", (event) ->
    console.log "Received message from client!", event
  client.on "disconnect", ->
    clearInterval interval
    console.log "Server has disconnected"
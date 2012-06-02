io = require("socket.io")
express = require("express")
server = express.createServer()
server.use express.static(__dirname + "/public")
server.listen 8080
socket = io.listen(server)
socket.sockets.on "connection", (client) ->
  interval = setInterval(->
    client.send "This is a message from the server!  " + new Date().getTime()
  , 5000)
  client.on "message", (event) ->
    console.log "Received message from client!", event

  client.on "disconnect", ->
    clearInterval interval
    console.log "Server has disconnected"
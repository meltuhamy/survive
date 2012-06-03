io = require("socket.io")
express = require("express")
server = express.createServer()
server.use express.static(__dirname + "/public")
server.listen 8080
socket = io.listen(server)

getSocketsArray = ->
  socketsArray = []
  socket.sockets.clients('game').forEach( (thesocket) ->  socketsArray.push thesocket)
  return socketsArray

socket.sockets.on "connection", (client) ->
  client.join('game')
  client.emit('createMyPlayer',parseInt(client.id))
  socketArray = getSocketsArray()
  if(socketArray.length >=2 )
    socket.sockets.in('game').emit('roommsg', "LET THE GAMES BEGIIIN!")
    socket.sockets.in('game').emit('gamestart')
  socket.sockets.in('game').emit('roommsg', socketArray.length)
  client.send "Your id is #{client.id}"
  ###interval = setInterval(->
    client.send "This is a message from the server!"
  , 10000)###
  client.on "message", (event) ->
    console.log "Received message from client!", event
  client.on "disconnect", ->
    #clearInterval interval
    console.log "Server has disconnected"
  client.on "startmeup", ->
    startMeSocketArray = getSocketsArray()
    otherPlayers = []
    otherPlayers.push {id: parseInt(otherClient.id)} for otherClient in startMeSocketArray when otherClient.id isnt client.id
    client.emit "startmeup", otherPlayers
  client.on "receivePlayer", (playerReceived) ->
    socket.sockets.in('game').emit('receivePlayer', playerReceived)
  client.on "itemChannel", (itemChange) ->
    socket.sockets.in('game').emit('itemChannel', itemChange)
  client.on "tileChannel", (tileChange) ->
    socket.sockets.in('game').emit('tileChannel', tileChange)
    
socketiolib = require("socket.io")
express = require("express")
server = express.createServer()
server.use express.static(__dirname + "/public")
server.listen 8080
io = socketiolib.listen(server)

class Room
  constructor: (@roomNumber) ->
    @setFriendlyName(@getName)
  isEmpty: -> @getPlayerCount() == 0
  getName: -> "room#{@roomNumber}"
  getFriendlyName: -> @friendlyName
  setFriendlyName: (name) -> @friendlyName = name
  hasStarted: -> false
  getScokets: -> 
    socketsArray = []
    io.sockets.clients(@getName()).forEach( (thesocket) ->  socketsArray.push thesocket)
    return socketsArray
  getPlayerIdsExceptFor: (searchId) ->
    ids = []
    ids.push {id: parseInt(aclient.id)} for aclient in @getSockets() when aclient.id isnt searchId
    return ids
  getPlayerIds: ->
    ids = []
    ids.push {id: parseInt(aclient.id)} for aclient in @getSockets()
    return ids
  getPlayerCount: -> @getIds().length
  joinRoom: (client) -> client.join(@getName())
  leaveRoom: (client) -> client.leave(@getName())
  emit: (eventName, data) -> io.sockets.in(@getName()).emit(eventName, data)

numRooms = 10
rooms = []
rooms.push new Room(i) for i in [0...10]
roomsToSend = []
roomsToSend.push {name: r.getName(), number: r.roomNumber} for r in rooms

io.sockets.on "connection", (client) ->
  # Lobby stuff
  client.join('lobby')
  io.sockets.in('lobby').emit("serverSendingRooms", roomsToSend)
  client.on "clientSendingRoomNumber", (roomNumber) ->
    rooms[roomNumber].joinRoom(client)
    rooms[roomNumber].emit("message", "hello, room #{roomNumber}")



  ###
  client.emit('createMyPlayer',parseInt(client.id))
  client.send("#{io.sockets.clients('game').name}")
  socketArray = getSocketsArray()
  if(socketArray.length >=2 )
    io.sockets.in('game').emit('roommsg', "LET THE GAMES BEGIIIN!")
    io.sockets.in('game').emit('gamestart')
  io.sockets.in('game').emit('roommsg', socketArray.length)
  client.send "Your id is #{client.id}"
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
    io.sockets.in('game').emit('receivePlayer', playerReceived)
  client.on "itemChannel", (itemChange) ->
    io.sockets.in('game').emit('itemChannel', itemChange)
  client.on "tileChannel", (tileChange) ->
    io.sockets.in('game').emit('tileChannel', tileChange)
  ###
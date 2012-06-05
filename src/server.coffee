socketiolib = require("socket.io")
express = require("express")
server = express.createServer()
server.use express.static(__dirname + "/public")
server.listen 8080
io = socketiolib.listen(server)


###
Database Stuff
Server:             db
Port:               5432
Database:           g1127112_u
Account:            g1127112_u
Password:           nrG0gKR1QC
PostgreSQL version: 8.3

###
pg = require("pg")
#            postgres://[user]:[pass]@[host]:[port]/[database]
conString = "postgres://g1127112_u:nrG0gKR1QC@db:5432/g1127112_u"
pg.connect conString, (err, client) ->
  client.query "SELECT NOW() as when", (err, result) ->
    console.log "Row count: %d", result.rows.length
    console.log "Current year: %d", result.rows[0].when.getYear()



class Room
  constructor: (@roomNumber, @maxPlayers = 2, @ingame = false) ->
    @setFriendlyName(@getName)
  isEmpty: -> @getPlayerCount() == 0
  getName: -> "room#{@roomNumber}"
  getFriendlyName: -> @friendlyName
  setFriendlyName: (name) -> @friendlyName = name
  hasStarted: -> false
  getSockets: -> 
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
  getPlayerCount: -> @getPlayerIds().length
  joinRoom: (client) -> client.join(@getName())
  leaveRoom: (client) -> client.leave(@getName())
  emit: (eventName, data) -> io.sockets.in(@getName()).emit(eventName, data)
  isFull: -> 
    console.log "isFull: #{@getPlayerCount()} == #{@maxPlayers} #{@getPlayerCount() == @maxPlayers}"
    @getPlayerCount() == @maxPlayers
  isInGame: -> @ingame
  setInGame: (val) -> @ingame = val

getRoomByName = (name) ->
  rooms[parseInt(name.substring(4))]

numRooms = 10
rooms = []
rooms.push new Room(i) for i in [0...10]
roomsToSend = []
roomsToSend.push {name: r.getName(), number: r.roomNumber} for r in rooms

io.sockets.on "connection", (client) ->
  # Lobby stuff
  client.join('lobby')
  client.emit("serverSendingRooms", roomsToSend)

  client.on "clientSendingRoomNumber", (roomNumber) ->
    client.leave('lobby')
    currentroom = rooms[roomNumber]
    if(!currentroom.isInGame() && !currentroom.isFull())
      currentroom.joinRoom(client)
      client.emit("message", "Welcome to room \"#{currentroom.getFriendlyName}\". Your id is #{client.id}")
      client.emit('serverSendingAcceptJoin', {id: parseInt(client.id), roomNumber: roomNumber})
      if(currentroom.isFull())
        currentroom.emit('beginGame', currentroom.getPlayerIds())
        currentroom.setInGame true

  client.on "clientSendingPlayerData", (playerData) ->
    rooms[playerData.roomNumber].emit('serverSendingPlayerData', playerData)

  client.on "clientSendingItemData", (itemData) ->
    rooms[itemData.roomNumber].emit('serverSendingItemData', itemData)

  client.on "clientSendingTileData", (tileData) ->
    rooms[tileData.roomNumber].emit('serverSendingTileData', tileData)

  client.on "disconnect", ->
      for key, val of io.sockets.manager.roomClients[client.id]
        console.log "#{key}, #{val}"
        if (key isnt '' && key isnt '/lobby')
          console.log key
          console.log getRoomByName(key.substring(1))
          leavingRoom = getRoomByName(key.substring(1))
          leavingRoom.emit("serverSendingPlayerDisconnected", client.id)
          if leavingRoom.getPlayerCount() == 2
            leavingRoom.setInGame false
            leavingRoom.emit("serverSendingReload", '')
      console.log ">>>>>>>>>>>>>>>>>>>>>>>. Server #{client.id} has disconnected"


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
  ###
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
dbClient = new pg.Client({user: 'g1127112_u', password: 'nrG0gKR1QC', host: 'db', port: 5432, database: 'g1127112_u'});
dbClient.connect()
dbClient.query "SELECT * from actions", (err, result) ->
    console.log "TOTAL: Row count: %d", result.rows.length


dbClient.on('error', (error) -> 
  console.log "<><><><><><><><ERRROR><><><><><><><>"
  console.log(error)
  console.log "<><><><><><><><><><><><><><><><><><>"
)

printRowCount = (thegameid=0)->
  dbClient.query "SELECT * from actions where gameid=#{thegameid}", (err, result) ->
    console.log "Row count for game #{thegameid}: %d", result.rows.length
###
pg.connect conString, (err, dbClient) ->
  dbClient.query "SELECT * from actions", (err, result) ->
    console.log "Row count: %d", result.rows.length
    #console.log "Current year: %d", result.rows[0].when.getYear()
###

tile0 =  [1,2,3,4,5,6,7,8,9,6,7,8,9,4,4,4,5,5,5,5,5,5,5,5,5,5,3,3,3,3,1,1,1,1,1,1,1,3,3,3,4,4,4,4,4,4,5,5,1,1,1,1,1,1,3,5,3,3,3,3,1,1,1,1,1,1,1,3,3,4,4,3,3,4,4,5,5,5,1,1,1,3,3,3,5,5,3,1,1,3,1,1,1,1,1,1,1,1,4,4,3,3,3,3,3,5,5,5,5,3,3,3,3,5,5,1,1,1,1,3,1,1,1,1,1,1,1,1,4,4,1,3,3,3,3,3,3,3,3,3,3,5,5,1,1,1,1,4,4,3,1,1,1,1,1,1,1,1,1,4,4,1,1,3,3,3,3,3,1,1,1,1,1,1,1,1,1,4,4,3,1,1,1,1,1,1,1,1,1,4,4,4,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,4,3,1,1,1,1,1,1,1,1,1,1,4,4,4,4,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,1,1,1,1,1,1,1,1,1,1,4,4,4,4,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,3,3,1,1,1,1,1,1,1,1,1,1,4,4,4,4,1,1,1,1,1,1,1,1,1,1,1,1,3,1,3,3,1,1,1,1,1,1,1,1,1,1,1,4,4,4,4,1,1,1,1,1,1,1,1,1,1,1,3,1,3,3,1,1,1,1,1,1,1,1,1,1,1,1,4,4,4,4,1,1,1,1,1,1,1,1,1,1,3,3,3,3,3,1,1,1,1,1,1,1,1,1,1,1,1,4,4,4,4,1,1,1,1,1,1,1,1,1,3,3,3,3,3,1,1,1,1,3,3,1,1,1,1,1,1,1,4,4,4,4,4,5,5,5,5,5,1,1,3,3,3,3,3,3,3,1,1,1,3,3,1,1,1,1,1,1,1,1,4,4,4,5,5,5,5,5,5,1,3,3,4,4,3,3,2,3,1,3,1,3,1,1,1,1,1,1,1,5,5,5,5,5,5,5,5,5,5,1,3,3,4,4,3,3,2,1,3,3,1,1,1,1,1,1,5,5,5,5,5,5,5,5,5,5,5,5,5,5,3,3,4,4,3,3,2,2,1,1,1,1,1,1,1,1,5,5,5,5,5,5,5,5,5,5,5,5,5,5,3,3,3,3,3,3,2,2,1,1,1,1,1,1,1,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,5,5,5,5,5,5,5,5,5,5,5,3]
item0 = [9, 10, 3, 5, 4, 5, 6, 7, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

map0 = {tiles: tile0, items: item0, mapwidth: 20, mapheight: 30, spawnSpots:[{tilex:11, tiley:9},{tilex:2, tiley:1}, {tilex:0, tiley:11}, {tilex:21, tiley:12}]}


class Room
  constructor: (@roomNumber, @mapData = map0, @maxPlayers = 2) ->
    @setFriendlyName(@getName())
    @maxPlayerCount = @maxPlayers
  ingame: false
  intervalid: null
  secondsElapsed: 0
  friendlyName: ""
  slotTaken: -1
  maxPlayerCount: @maxPlayers

  isEmpty: -> @getPlayerCount() == 0
  isFull: ->  @getPlayerCount() == @maxPlayers
  getName: -> "room#{@roomNumber}"
  getFriendlyName: -> @friendlyName
  setFriendlyName: (name) => @friendlyName = name


  getSockets: -> 
    sockets = []
    io.sockets.clients(@getName()).forEach((s) ->  sockets.push s)
    return sockets
  getSocketsExceptFor: (searchId) ->
    sockets = []
    io.sockets.clients(@getName()).forEach((s) ->  sockets.push s if s.startid isnt searchId)
    return sockets
  getPlayerIdsExceptFor: (searchId) ->
    ids = []
    ids.push {id: c.startid} for c in @getSockets() when c.startid isnt searchId
    return ids
  getPlayerIds: ->
    ids = []
    ids.push {id: c.startid} for c in @getSockets()
    return ids

  getPlayerCount: -> @getPlayerIds().length
  addPlayer: (client) -> 
    client.join(@getName())
    client.emit("serverSendingRooms", roomsToSend())
    client.broadcast.emit("serverSendingRooms", roomsToSend())

  emit: (eventName, data) -> io.sockets.in(@getName()).emit(eventName, data)
  
  isInGame: => @ingame
  getNextSlot: =>
    if(@slotTaken==-1)
      @slotTaken = Math.floor(Math.random() * @mapData.spawnSpots.length)
    else
      @slotTaken = (@slotTaken + 1 ) % @mapData.spawnSpots.length
  getSpawnLocation: =>
    @mapData.spawnSpots[@getNextSlot()]
  requestJoin: (client) =>
    # if the requested game room is not full and hasn't started then he can join
    if(!@isInGame() && !@isFull())
      @addPlayer(client)
      client.emit("message", "Welcome to room #{@friendlyName}. Your id is #{client.startid}")
      spawnLocation = @getSpawnLocation()
      spawnData = {id: client.startid, roomNumber: @roomNumber, tilex: spawnLocation.tilex, tiley:spawnLocation.tiley}
      client.emit('serverSendingAcceptJoin', {spawn: spawnData, themap: @mapData})
      # if the room is full *after* he has joined - then start the game
      if(@isFull())
        @startGame()

  startGame: =>
    console.log ">>>>>>>>>>>>>>>>>>>>>>>>STARTING GAME!! :D"
    @emit('serverSendingBeginGame', @getPlayerIds())
    @ingame = true
    @intervalid = setInterval @roomLoop, 1000


  roomLoop: =>
    # increase seconds timer for game
    @secondsElapsed++
    # spawn a water bottle in a random location every ten seconds
    if(@secondsElapsed % 10 == 0)
      # 0 <= randomx < 20
      randomx = Math.floor(Math.random() * 20)
      randomy = Math.floor(Math.random() * 20)
      itemData = {id: 60, roomNumber:@roomNumber, tilex: randomx, tiley: randomy, itemNumber: 2}
      @sendItem itemData

  endGame: (clientId)=>
    @ingame = false
    @emit("serverSendingReload", '')
    clearInterval @intervalid

  sendPlayer: (playerData, clientid) ->
    @emit('serverSendingPlayerData', playerData)
    dbClient.query "insert into actions values (NOW(), #{playerData.roomNumber}, #{clientid}, 'p', #{playerData.tilex}, #{playerData.tiley});", (err, result) ->
      console.log "INSERTED ROW"
    printRowCount()

  sendItem: (itemData, clientid) -> 
    # if the clientid parameter is not given, assume server is sending the update
    # if this is the case, itemData.id will be 0
    @emit('serverSendingItemData', itemData)
    clientidstr = if(clientid?) then "#{clientid}" else "NULL" 
    dbClient.query "insert into actions values (NOW(), #{itemData.roomNumber}, #{clientidstr}, 'i', #{itemData.tilex}, #{itemData.tiley}, #{itemData.itemNumber});", (err, result) -> 
      console.log "INSERTED ROW"
    printRowCount()

  sendTile: (tileData, clientid) -> 
    # if the clientid parameter is not given, assume server is sending the update
    # if this is the case, tileData.id will be 0
    @emit('serverSendingTileData', tileData)
    clientidstr = if(clientid?) then "#{clientid}" else "NULL" 
    dbClient.query "insert into actions values (NOW(), #{tileData.roomNumber}, #{clientidstr}, 't', #{tileData.tilex}, #{tileData.tiley}, #{tileData.tileNumber});", (err, result) ->
      console.log "INSERTED ROW"
    printRowCount()

  sendAttack: (attackData) ->
    @emit('serverSendingAttackData', attackData)

  sendDeath: (deathData, client) ->
    client.dead = true
    @emit('serverSendingDeathData', deathData)
    console.log "TEEEEEEEEEEESTING #{deathData.id}, #{client.startid}"
    @checkGameover()
    
  checkGameover: ->
    alive = []
    alive.push s for s in @getSockets() when !s.dead?
    if(alive.length == 1)
      winnerid = alive[0]
      console.log "WEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE HAVE A WINNER:"
      console.log winnerid.startid
      console.log "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!WELLDONE!!!!!!!!!!!!!!!!!!!!!!!"
      @emit('serverSendingWinnder',winnerid.startid)


getRoomByName = (name) ->
  rooms[parseInt(name.substring(4))]


numRooms = 10
rooms = []
rooms.push new Room(i) for i in [0...numRooms]

roomsToSend = ->
  roomsData = []
  for r in rooms
    roomData = {
      name: r.getName(),
      roomNumber: r.roomNumber,
      friendlyName: "#{r.getFriendlyName()}",
      playerCount: r.getPlayerCount(),
      maxPlayerCount: r.maxPlayerCount,
      ingame: r.ingame
    }
    roomsData.push roomData
  return roomsData

io.sockets.on "connection", (client) ->
  # Lobby stuff
  client.join('lobby')
  client.startid = client.id

  console.log "CONNECT: #{client.startid}"

  # Send the list of rooms to the client

  client.emit("serverSendingRooms", roomsToSend())

  # The client has request to join a room
  client.on "clientSendingRoomNumber", (roomNumber) ->
    client.leave('lobby')
    console.log "SENDING ROOM NUMBER: #{client.startid}"
    requestedRoom = rooms[roomNumber].requestJoin(client)
    
  client.on "clientSendingPlayerData", (playerData) ->
    rooms[playerData.roomNumber].sendPlayer(playerData, client.startid)

  client.on "clientSendingItemData", (itemData) ->
    rooms[itemData.roomNumber].sendItem(itemData, client.startid)

  client.on "clientSendingTileData", (tileData) ->
    rooms[tileData.roomNumber].sendTile(tileData, client.startid)

  client.on "clientSendingAttackData", (attackData) ->
    rooms[attackData.roomNumber].sendAttack(attackData)

  client.on "clientSendingDeathData", (deathData) ->
    rooms[deathData.roomNumber].sendDeath(deathData, client)

  client.on "clientSendingReplayRequest", (deathData) ->
    query = dbClient.query("SELECT * FROM actions WHERE gameid = #{deathData.roomNumber}");
    replayData = []
    query.on 'row', (row, result) ->
      replayData.push(row)
    query.on 'end', (result) ->
      client.emit("serverSendingReplay", replayData)

  client.on "disconnect", ->
    console.log "<<<<<<<CLIENT DISCONNECTED>>>>>>> "
    console.log "DISCONNECTED: #{client.startid}"
    client.broadcast.emit("serverSendingRooms", roomsToSend())
    client.dead = true
    for key, val of io.sockets.manager.roomClients[client.id]
      if (key isnt '' && key isnt '/lobby')
        leavingRoom = getRoomByName(key.substring(1))
        leavingRoom.checkGameover()
        leavingRoom.emit("serverSendingPlayerDisconnected", client.startid)
        # if two people currently connected in room and one leaves, end the game
        if  0<leavingRoom.getPlayerCount()<=2
          console.log "<<<<<<<<<<<<<<<GAME ENDED>>>>>>>>>>>>>>>>"
          leavingRoom.endGame()

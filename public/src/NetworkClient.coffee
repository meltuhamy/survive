class NetworkClient
  @OFFLINEMODE: false
  @winnerRecieved: false

  @log = (message) =>
    $('.serverdebugbar').append("<li>#{message}</li>")

  @sendJoinRoomRequest = (roomNumber) ->
    socket.emit "clientSendingRoomNumber", roomNumber

  @sendPlayerData = ->
    playerData = {id: Game.player.id, roomNumber: Game.player.roomNumber, tilex: Game.player.tilex, tiley: Game.player.tiley, spriteNumber: Game.player.spriteNumber, direction: Game.player.direction}
    if !@OFFLINEMODE then socket.emit "clientSendingPlayerData", playerData

  @sendItemData = (itemData) ->
    if !@OFFLINEMODE then socket.emit "clientSendingItemData", itemData

  @sendTileData = (tileData) ->
    if !@OFFLINEMODE then socket.emit "clientSendingTileData", tileData

  @sendAttackData = (attackData) ->
    if !@OFFLINEMODE
      socket.emit "clientSendingAttackData", attackData

  @sendDeathData = (deathData) ->
     if !@OFFLINEMODE
      socket.emit "clientSendingDeathData", deathData

  @receiveRoomJoin = (initialData) ->
    if initialData.themap?
      gameMap = initialData.themap
      console.log "Received game map. Width: #{gameMap.mapwidth} Height: #{gameMap.mapheight}"
      map = new Map(new Grid(gameMap.tiles, gameMap.mapwidth, gameMap.mapheight), new Grid(gameMap.items, gameMap.mapwidth, gameMap.mapheight))
    Game.spawnPlayer(initialData.spawn)
    
  @receiveGameStart = (allplayers) ->
    Game.start(allplayers)

  @receivePlayerData = (playerData) ->
    if playerData.id != Game.player.id
      playerindex = Game.getPlayerIndexById(playerData.id)
      opponent = Game.opponents[playerindex]
      if(opponent.alive)
        opponent.tilex = playerData.tilex
        opponent.tiley = playerData.tiley
        opponent.direction = playerData.direction
        opponent.spriteNumber = playerData.spriteNumber

  @receiveReplay = (replayData) =>
    Game.gameReplay(replayData)

  @receiveDeathData = (deathData) =>
    if deathData.id != Game.player.id
      Game.opponentDeath(deathData)

  @receiveWinner = (winnerID) =>
    if !@winnerRecieved
      if winnerID == Game.player.id then Game.announce "You won!" else Game.announce "Everyone is good at something. You're good at losing. #{winnerID} won!"
      @winnerRecieved = true

  @receiveOpponentDisconnect = (id) =>
    Game.opponentDisconnect(id)

  @receiveItemData = (itemData) ->
    if itemData.id != Game.player.id
      map.setItemElement itemData.tilex, itemData.tiley, itemData.itemNumber, false

  @receiveAttackData = (attackData) ->
    if ((attackData.id != Game.player.id) && (attackData.tilex == Game.player.tilex) && (attackData.tiley == Game.player.tiley))
      Game.player.attack(attackData.damage)

  @receiveTileData = (tileData) ->
    if tileData.id != Game.player.id
      map.setTileElement tileData.tilex, tileData.tiley, tileData.tileNumber, false

  @receiveRooms = (roomData) =>
    $("#roomlist").empty()
    $("#roomlist").append("<table id=\"rooms\">")
    # header row
    $("#roomlist").append("<tr><th>No.</th><th>Room Name</th><th>Players</th><th>Status</th></tr>")
    # one row for each room
    for r in roomData
      tableData = "<td>#{r.roomNumber}</td>"
      tableData += "<td><a onclick=\"NetworkClient.sendJoinRoomRequest(#{r.roomNumber})\">#{r.friendlyName}</a></td>"
      tableData += "<td>#{r.playerCount} / #{r.maxPlayerCount}</td>"
      tableData += if (r.ingame) then "<td>Playing!</td>" else "<td>Waiting for more players</td>"
      $("#roomlist").append("<tr>#{tableData}</tr>") 
    $("#roomlist").append("</table>")

endingGame = ->
  socket.disconnect()
  Game.announce "<span style=\"color:red;\">There are no other players in this room and the game has ended. You have been disconnected. Refresh your browser to join another room</span>"

socket = io.connect()

socket.on "connect", ->
  #NetworkClient.onConnectToServer()
  #NetworkClient.log "<span style=\"color:green;\">Client has connected to the server!</span>"

socket.on "serverSendingRooms", (rooms) ->
  NetworkClient.receiveRooms(rooms)

socket.on "serverSendingAcceptJoin", (initialData) ->
  NetworkClient.receiveRoomJoin(initialData)
  
socket.on "serverSendingBeginGame", (allplayers) ->
  NetworkClient.receiveGameStart(allplayers)
  #NetworkClient.log "<span style=\"color:red;\">Other Players Received! #{Game.opponents}</span>"

socket.on "disconnect", ->
  #NetworkClient.log "<span style=\"color:red;\">The client has disconnected!</span>"

socket.on "serverSendingPlayerData", (playerData) ->
  NetworkClient.receivePlayerData(playerData)

socket.on "serverSendingItemData", (itemData) ->
  NetworkClient.receiveItemData(itemData)

socket.on "serverSendingTileData", (tileData) ->
  NetworkClient.receiveTileData(tileData)

socket.on "serverSendingAttackData", (attackData) ->
  NetworkClient.receiveAttackData(attackData)

socket.on "serverSendingDeathData", (deathData) ->
  NetworkClient.receiveDeathData(deathData)

socket.on "serverSendingWinner", (winnerID) ->
  NetworkClient.receiveWinner(winnerID)

socket.on "message", (data) ->
  NetworkClient.log "Received: #{data}"

socket.on "serverSendingPlayerDisconnected", (id) ->
  NetworkClient.receiveOpponentDisconnect(id)

socket.on "serverSendingReload", (data) ->
  endingGame()

socket.on "serverSendingReplay", (replayData) ->
  NetworkClient.receiveReplay(replayData)

socket.on "serverSendingDebugLog", (debugLogData) ->
  console.log debugLogData

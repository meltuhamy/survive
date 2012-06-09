class NetworkClient
  @OFFLINEMODE: false

  @log = (message) =>
    li = document.createElement("li")
    li.innerHTML = message
    document.getElementById("message-list").appendChild li
    $('#message-list').prepend(li)

  @sendJoinRoomRequest = (roomNumber) ->
    socket.emit "clientSendingRoomNumber", roomNumber

  @sendPlayerData = ->
    playerData = {id: Game.player.id, roomNumber: Game.player.roomNumber, tilex: Game.player.tilex, tiley: Game.player.tiley}
    if !@OFFLINEMODE then socket.emit "clientSendingPlayerData", playerData

  @sendItemData = (itemData) ->
    if !@OFFLINEMODE then socket.emit "clientSendingItemData", itemData

  @sendTileData = (tileData) ->
    if !@OFFLINEMODE then socket.emit "clientSendingTileData", tileData

  @receiveRoomJoin = (spawnData) ->
    Game.spawnPlayer(spawnData)
    
  @receiveGameStart = (allplayers) ->
    Game.start(allplayers)

  @receivePlayerData = (playerData) ->
    if playerData.id != Game.player.id
      playerindex = Game.getPlayerIndexById(playerData.id)
      Game.opponents[playerindex].tilex = playerData.tilex
      Game.opponents[playerindex].tiley = playerData.tiley

  @receiveReplay = (replayData) =>
    Game.gameReplay replayData

  @receiveOpponentDisconnect = (id) =>
    Game.removePlayerFromArray id

  @receiveItemData = (itemData) ->
    if itemData.id != Game.player.id
      map.setItemElement itemData.tilex, itemData.tiley, itemData.itemNumber, false

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


socket = io.connect()

socket.on "connect", ->
  #NetworkClient.onConnectToServer()
  #NetworkClient.log "<span style=\"color:green;\">Client has connected to the server!</span>"

socket.on "serverSendingRooms", (rooms) ->
  NetworkClient.receiveRooms(rooms)

socket.on "serverSendingAcceptJoin", (spawnData) ->
  NetworkClient.receiveRoomJoin(spawnData)
  
socket.on "beginGame", (allplayers) ->
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

socket.on "message", (data) ->
  NetworkClient.log "Received: #{data}"

socket.on "serverSendingPlayerDisconnected", (id) ->
  NetworkClient.receiveOpponentDisconnect(id)

socket.on "serverSendingReload", (data) ->
  window.location.reload()

socket.on "serverSendingReplay", (replayData) ->
  NetworkClient.receiveReplay(replayData)

socket.on "serverSendingDebugLog", (debugLogData) ->
  console.log debugLogData
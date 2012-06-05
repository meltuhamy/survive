
getPlayerIndexById = (id) ->
    listofids = []
    listofids.push aplayer.id for aplayer in otherplayers
    return listofids.indexOf(id)


###
Joining and leaving Rooms
###  

clientJoinRoom = (roomNumber) ->
  socket.emit "clientSendingRoomNumber", roomNumber

###
Messages
###  

sendMessageToServer = (message) ->
  socket.send message
  log "<span style=\"color:#888\">Sending \"" + message + "\" to the server!</span>"


###
Sending player position
###  

sendPlayerData = ->
  #console.log "sending player!!!"
  #console.log {id: player.id, roomNumber: player.roomNumber, tilex: player.tilex, tiley: player.tiley}
  if !DEBUGMODE then socket.emit "clientSendingPlayerData", {id: player.id, roomNumber: player.roomNumber, tilex: player.tilex, tiley: player.tiley} 

receivePlayerData = (playerData)->
  console.log "Received a player!"
  console.log playerData
  if playerData.id != player.id
    playerindex = getPlayerIndexById(playerData.id)
    otherplayers[playerindex].tilex = playerData.tilex
    otherplayers[playerindex].tiley = playerData.tiley

###
Sending and receiving updates to the items
###  

sendItemData  = (itemData) ->
  if !DEBUGMODE then socket.emit "clientSendingItemData", {id: player.id, roomNumber: player.roomNumber, tilex: itemData.tilex, tiley: itemData.tiley, itemNumber: itemData.itemNumber}

receiveItemData = (itemData) ->
  #console.log itemChange
  if itemData.id != player.id
    map.setItemElement itemData.tilex, itemData.tiley, itemData.itemNumber, false

###
Sending and receiving updates to the tiles
###  

sendTileData = (tileData) ->
  if !DEBUGMODE then socket.emit "clientSendingTileData", {id: player.id, roomNumber: player.roomNumber, tilex: tileData.tilex, tiley: tileData.tiley, tileNumber: tileData.tileNumber}

receiveTileData = (tileData) ->
  #console.log itemChange
  if tileData.id != player.id
    map.setTileElement tileData.tilex, tileData.tiley, tileData.tileNumber, false



log = (message) ->
  li = document.createElement("li")
  li.innerHTML = message
  document.getElementById("message-list").appendChild li
  $('#message-list').prepend(li)


socket = io.connect()
socket.on "connect", ->
  log "<span style=\"color:green;\">Client has connected to the server!</span>"

socket.on "serverSendingRooms", (rooms) ->
  addRooms rooms

socket.on "serverSendingAcceptJoin", (playerParams) ->
  console.log "Accepted!! player stuff:"
  console.log playerParams
  createMyPlayer(playerParams)

socket.on "beginGame", (allplayers) ->
  gamestart(allplayers)
  log "<span style=\"color:red;\">Other Players Received! #{otherplayers}</span>"

socket.on "disconnect", ->
  log "<span style=\"color:red;\">The client has disconnected!</span>"

socket.on "serverSendingPlayerData", (playerData) ->
  console.log "Received player movement"
  receivePlayerData playerData

socket.on "serverSendingItemData", (itemData) ->
  receiveItemData itemData

socket.on "serverSendingTileData", (tileData) ->
  receiveTileData tileData

socket.on "message", (data) ->
  log "Received: #{data}"

socket.on "serverSendingPlayerDisconnected", (id) ->
  removePlayerFromArray id

socket.on "serverSendingReload", (data) ->
  window.location.reload()

###
socket.on "ijoined", (myid)->
  player.playerid = myid
  console.log myid
socket.on "gamestart", ->
  socket.emit "startmeup"
  log "<span style=\"color:red;\">Game started!</span>"
socket.on "createMyPlayer", (id) ->
  createMyPlayer(id)
socket.on "startmeup", (otherplayers) ->
  gamestart(otherplayers)
  log "<span style=\"color:red;\">Other Players Received!</span>"
socket.on "roommsg", (data) ->
  log "<span style=\"color:green;\">#{data}</span>"
###

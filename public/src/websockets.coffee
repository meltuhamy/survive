sendMessageToServer = (message) ->
  socket.send message
  log "<span style=\"color:#888\">Sending \"" + message + "\" to the server!</span>"

sendMoveToServer = (move) ->
  socket.send move
  log "<span style=\"color:#888\">Move made \"" + message + "\" to the server!</span>"

sendPlayer = ->
  socket.emit "receivePlayer", {id: player.id, tilex: player.tilex, tiley: player.tiley}

getPlayerIndexById = (id) ->
    listofids = []
    listofids.push aplayer.id for aplayer in otherplayers
    return listofids.indexOf(id)

receivePlayer = (receivedPlayer)->
  #console.log "Received a player!"
  #console.log receivedPlayer
  if receivedPlayer.id != player.id
    playerindex = getPlayerIndexById(receivedPlayer.id)
    otherplayers[playerindex].tilex = receivedPlayer.tilex
    otherplayers[playerindex].tiley = receivedPlayer.tiley

clientJoinRoom = (roomNumber) ->
  socket.emit "clientSendingRoomNumber", roomNumber

sendItem = (playerId, x, y, num) ->
  itemObj = {pid: playerId, tilex: x, tiley: y, itemnum: num}
  socket.emit "itemChannel", itemObj
  #console.log itemObj

updateItems = (itemChange) ->
  #console.log itemChange
  if itemChange.playerId != player.id
    map.setItemElement itemChange.tilex, itemChange.tiley, itemChange.itemnum, false

sendTile = (playerId, x, y, num) ->
  tileObj = {pid: playerId, tilex: x, tiley: y, tilenum: num}
  socket.emit "tileChannel", tileObj
  console.log tileObj

updateTiles = (tileChange) ->
  #console.log itemChange
  if tileChange.playerId != player.id
    map.setTileElement tileChange.tilex, tileChange.tiley, tileChange.tilenum, false


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
socket.on "ijoined", (myid)->
  player.playerid = myid
  console.log myid
socket.on "message", (data) ->
  log "Received: #{data}"
socket.on "roommsg", (data) ->
  log "<span style=\"color:green;\">#{data}</span>"
socket.on "disconnect", ->
  log "<span style=\"color:red;\">The client has disconnected!</span>"
socket.on "gamestart", ->
  socket.emit "startmeup"
  log "<span style=\"color:red;\">Game started!</span>"
socket.on "createMyPlayer", (id) ->
  createMyPlayer(id)
socket.on "startmeup", (otherplayers) ->
  gamestart(otherplayers)
  log "<span style=\"color:red;\">Other Players Received!</span>"
socket.on "receivePlayer", (playerReceived) ->
  receivePlayer playerReceived
socket.on "itemChannel", (itemChange) ->
  updateItems itemChange
socket.on "tileChannel", (tileChange) ->
  updateTiles tileChange

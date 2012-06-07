DEBUGMODE = off

tileWidth = 25
tileHeight = 25

canvasWidth = 900
canvasHeight = 600

fullWidth = tileWidth*map.tileGrid.numcols
fullHeight = tileHeight*map.tileGrid.numrows


gamestarted = false
player = new Player()
otherplayers = []


mousex = 0
mousey = 0
mouseSquarex = 0
mouseSquarey = 0

scrollx = 0.0
scrollxvel = 0.0
scrollxacc = 0.0
scrolly = 0.0
scrollyvel = 0.0
scrollyacc = 0.0
scrollRegion = 0.15
scrollAccConst = 0.12

filterReady = false
focusOnCanvas = true

actionMenuVisible = false
actionMenuSelected = 0
actionMenuTotal = 0
actionMenuTileX = 0
actionMenuTileY = 0

inventoryActionSelected = 0

filterImage = new Image()
filterImage.onload = => filterReady = true
filterImage.src = "#{window.assetDir}/filter.png"

replayData = []
replayMode = false
replayGameTick = 0
replayLoopIntervalId = 0

gameReplay = (receivedReplayData) ->
  clearInterval replayLoopIntervalId
  replayMode = true
  map.restore()
  replayData = receivedReplayData
  clearInterval mainLoopIntervalId
  replayLoopIntervalId = setInterval replayLoop, 40

#Initialisation events

gamestart = (players) ->
  otherplayers.push new Player(p.id, p.roomNumber) for p in players when p.id isnt player.id
  gamestarted = true
  $("#lobby").fadeOut()
  $(".game").fadeIn()

removePlayerFromArray = (id) ->
  otherplayers.splice getPlayerIndexById(id), 1

createPlayerJSON = (jsonAtrribs) ->
  otherplayers.push newPlayer(jsonAtrribs)

createMyPlayer = (playerParams) ->
  player = new Player(playerParams.id, playerParams.roomNumber)

addRooms = (rooms) ->
  $("#roomlist").append("<li><a onClick=\"clientJoinRoom(#{room.number})\">#{room.name}</a></li>") for room in rooms

$('#actionmenu').fadeOut()
# Makes the action menu for given coordinates
makemenu = (x,y) ->
   menuactions = map.getActions(x,y)    #first we get all actions available at given coordinates
   inputSelect = ''
   if (menuactions.length == 0) then return
   for i in [0...menuactions.length]
    inputSelect = inputSelect.concat('<li id="menuAction'+i+'">'+menuactions[i].actionname+'</li>')
   $('#actionmenu').css('top', y*tileHeight-scrolly)
   $('#actionmenu').css('left', x*tileWidth-scrollx)
   actionMenuSelected = 0
   actionMenuTileX = x
   actionMenuTileY = y
   actionMenuTotal = menuactions.length
   focusOnCanvas = false
   $('#actionlist').html inputSelect 
   $('#actionmenu ul li#menuAction0').toggleClass('selected')
   $('#actionmenu').fadeIn("fast")
   actionMenuVisible = true


actionMenuKeyDown = (evt) ->
  $('#actionmenu ul li#menuAction'+actionMenuSelected).toggleClass('selected')
  if(evt.keyCode == 38)
    actionMenuSelected = (actionMenuSelected-1+actionMenuTotal) % actionMenuTotal
  else if(evt.keyCode == 40)
    actionMenuSelected = (actionMenuSelected+1) % actionMenuTotal
  else if(evt.keyCode == 13)
    focusOnCanvas = true
    actions = map.getActions(actionMenuTileX, actionMenuTileY)
    selectedAction = actions[actionMenuSelected]
    $('#actionmenu').fadeOut("fast")
    actionmenuVisible = false
    selectedAction.doFn(actionMenuTileX, actionMenuTileY)
  else if(evt.keyCode == 27)
    focusOnCanvas = true
    $('#actionmenu').fadeOut("fast")
    actionmenuVisible = false
  $('#actionmenu ul li#menuAction'+actionMenuSelected).toggleClass('selected')
    
$('#inventoryActionsMenu').fadeOut()
# Makes the action menu for given coordinates
makeInventoryMenu = (itemIndex) ->
   itemNo = player.inventory[itemIndex]
   itemObj = map.getItemFromNumber itemNo
   menuactions = itemObj.inventoryActions
   inputSelect = ''
   if (menuactions.length == 0) then return
   for i in [0...menuactions.length]
     inputSelect = inputSelect.concat('<li id="itemAction'+i+'">'+menuactions[i].actionname+'</li>')
   $('#inventoryActionsMenu').css('top', 200)
   $('#inventoryActionsMenu').css('left', $('#inventorymenu ul li').eq(itemIndex).position().left)
   actionMenuSelected = 0
   inventoryActionMenuTotal = menuactions.length
   focusOnCanvas = false
   $('#inventoryActions').html inputSelect 
   $('#inventoryActions li#itemAction0').toggleClass('selected')
   $('#inventoryActions').fadeIn("fast")


inventoryActionKeyDown = (evt) ->
  $('#actionmenu ul li#menuAction'+inventoryActionSelected ).toggleClass('selected')
  if(evt.keyCode == 38)
    inventoryActionSelected = (inventoryActionSelected -1+inventoryActionMenuTotal) % inventoryActionMenuTotal
  else if(evt.keyCode == 40)
    inventoryActionSelected = (inventoryActionSelected +1) % inventoryActionMenuTotal 
  else if(evt.keyCode == 13)
    focusOnCanvas = true
    actions = map.getItemFromNumber(selectedItem).inventoryActions
    selectedAction = actions[inventoryActionSelected]
    $('#actionmenu').fadeOut("fast")
    selectedAction.doFn()
  else if(evt.keyCode == 27)
    focusOnCanvas = true
    $('#inventoryActionsnMenu').fadeOut("fast")
  $('#inventoryActionsMenu ul li#menuAction'+inventoryActionSelected).toggleClass('selected')
inventoryPopup = ->
  $('#inventorymenu').fadeToggle("fast")

pushInventory = (itemNo) ->
  itemObj = map.getItemFromNumber(itemNo)
  imgSource = itemObj.tileImage.src
  $('#inventorymenu #inventoryImages').append("<li class=\"item#{itemNo}\"><img src=\"#{imgSource}\"></img></li>")

$(document).ready ->

  #Dialogs
  $("#dialog").dialog({
      autoOpen: false
  });

  $("#message-list").dialog({
      autoOpen: true,
      height: 530
  });


  $('#inventorymenu').hide()
  if(!DEBUGMODE)
    $('.game').hide();

  # mouse move event within 'container' div
  $('#container').mousemove (evt) ->
    offset = $(@).offset()    # not quite sure what @ refers to, but this gets an offset
    mousex = Math.floor(evt.pageX - offset.left)    # sets mousex var to new mouse position
    mousey = Math.floor(evt.pageY - offset.top)     # sets mousey var to new mouse position
    #console.log("x,y : #{mousex},#{mousey}")

  # key up event
  $(document.documentElement).keyup (evt) ->
    #alert ("Key pressed! Value: #{evt.keyCode}") 
    if focusOnCanvas
      if (evt.keyCode == 87) #w pressed
        makemenu(player.tilex, player.tiley-1)
      if (evt.keyCode == 83) #s pressed
        makemenu(player.tilex, player.tiley+1)
      if (evt.keyCode == 65) #a
        makemenu(player.tilex-1, player.tiley)
      if (evt.keyCode == 68) #d
        makemenu(player.tilex+1, player.tiley)
      if (evt.keyCode == 49)
        makeInventoryMenu(0)
      if(evt.keyCode == 73)
        inventoryPopup()
      player.onKeyUp(evt)



  #key down event
  $(document.documentElement).keydown (evt) ->
    if focusOnCanvas
      player.onKeyDown(evt)
      if(evt.keyCode == 82) # press r
        replayGameTick = 0
        socket.emit "clientSendingReplayRequest", {roomNumber: player.roomNumber}
    else
      if actionMenuVisible
        actionMenuKeyDown(evt)
      else
        inventoryActionKeyDown(evt)




###
    Executes once page has loaded
###

window.onload = =>
  # Map layer
  window.mapLayer = new Kinetic.Layer()

  # Current square select layer
  window.hoverSelectLayer = new Kinetic.Layer()
  window.hoverSelectBox = new Kinetic.Rect(
    fill: 'yellow'
    width: tileWidth
    height: tileHeight
    alpha: 0.6
  )
  window.hoverSelectLayer.add window.hoverSelectBox

  # Item layer
  window.itemLayer = new Kinetic.Layer()

  # Player layer
  window.playerLayer = new Kinetic.Layer()

  
  # Create the kinetic stage
  window.stage = new Kinetic.Stage(
    container: "container"
    width: canvasWidth
    height: canvasHeight
  )
  # Add the layers to the stage
  window.stage.add window.mapLayer
  window.stage.add window.hoverSelectLayer
  window.stage.add window.itemLayer
  window.stage.add window.playerLayer
  

###
    Drawing to canvas
###

vision1 = [{x:0,y:0}, {x:1,y:0}, {x:0,y:1}, {x:-1,y:0}, {x:0,y:-1}]
vision2 = [{x:0,y:0},{x:-1,y:-1},{x:0,y:-1},{x:1,y:-1},{x:1,y:0},{x:1,y:1},{x:0,y:1},{x:-1,y:1},{x:-1,y:0},{x:-2,y:0},{x:0,y:-2},{x:0,y:2},{x:2,y:0}]

render = =>
  mapContext = window.mapLayer.getContext() # get map
  mapContext.fillStyle = "#000000" 
  mapContext.fillRect(0,0,canvasWidth,canvasHeight) # fill map black
  itemContext = window.itemLayer.getContext() # get drawing context for item layer
  itemLayer.clear()
  playerContext = window.playerLayer.getContext() # get drawing context for item layer
  playerLayer.clear()
  
  # for every grid location
  for y in [0...map.tileGrid.numrows]
    for x in [0...map.tileGrid.numcols]
      # if the corresponding tile is loaded
      if (map.getTile(x,y).tileReady)
        # draw the image on the map in the position relative to map scroll
        mapContext.drawImage map.getTile(x,y).tileImage, x*tileWidth-scrollx, y*tileHeight-scrolly
        if (filterReady)
            mapContext.drawImage filterImage, x*tileWidth-scrollx, y*tileHeight-scrolly

  # for every grid location in our vision
  for v in vision2
    visionx = player.tilex+v.x
    visiony = player.tiley+v.y 
    if(map.inBounds(visionx,visiony))
      # overwrite the grayed out tile with a full brightness map tile
      mapContext.drawImage map.getTile(visionx,visiony).tileImage, visionx*tileWidth-scrollx, visiony*tileHeight-scrolly
      # draw any items in our view
      if !map.noItem(visionx,visiony) 
        itemContext.drawImage map.getItem(visionx,visiony).tileImage, visionx*tileWidth-scrollx, visiony*tileHeight-scrolly
      # draw other players that are in our view
      for p in otherplayers
        if (p.tilex == visionx && p.tiley == visiony)
          playerContext.drawImage player.playerImage, visionx*tileWidth-scrollx, visiony*tileHeight-scrolly if player.imgReady

  # draw the yellow square for the tile the player is currently standing on
  window.hoverSelectBox.setX player.tilex*tileWidth - Math.floor(scrollx)
  window.hoverSelectBox.setY player.tiley*tileHeight - Math.floor(scrolly)
  window.hoverSelectLayer.draw()

  # draw the player that the client is controlling
  playerContext.drawImage player.playerImage, player.posx-scrollx, player.posy-scrolly if player.imgReady



replayGameRender = =>
  mapContext = window.mapLayer.getContext() # get map
  mapContext.fillStyle = "#000000" 
  mapContext.fillRect(0,0,canvasWidth,canvasHeight) # fill map black
  itemContext = window.itemLayer.getContext() # get drawing context for item layer
  itemLayer.clear()
  playerContext = window.playerLayer.getContext() # get drawing context for item layer
  playerLayer.clear()
  # for every grid location
  for y in [0...map.tileGrid.numrows]
    for x in [0...map.tileGrid.numcols]
      # if the corresponding tile is loaded
      if (map.getTile(x,y).tileReady)
        # draw the image on the map in the position relative to map scroll
        mapContext.drawImage map.getTile(x,y).tileImage, x*tileWidth-scrollx, y*tileHeight-scrolly
        if !map.noItem(x,y)
           itemContext.drawImage map.getItem(x,y).tileImage, x*tileWidth-scrollx, y*tileHeight-scrolly
  playerContext.drawImage player.playerImage, player.posx-scrollx, player.posy-scrolly if player.imgReady
  for p in otherplayers
    playerContext.drawImage player.playerImage, p.tilex*tileWidth-scrollx, p.tiley*tileHeight-scrolly if player.imgReady


replayGameUpdate = =>
  if replayGameTick < replayData.length
    replay = replayData[replayGameTick]
    console.log "Replaying row #{replayGameTick}:"
    console.log replay
    switch replayData[replayGameTick].type
      when "t"
        map.setTileElement replay.tilex, replay.tiley, replay.value, false
      when "i"
        map.setItemElement replay.tilex, replay.tiley, replay.value, false
      when "p"
        if replay.socketid != player.id
          playerindex = getPlayerIndexById(replay.socketid)
          otherplayers[playerindex].tilex = replay.tilex
          otherplayers[playerindex].tiley = replay.tiley
        else
          player.posx = replay.tilex*tileWidth
          player.posy = replay.tiley*tileHeight
          player.tilex = Math.floor((player.posx+12.5) / 25);
          player.tiley = Math.floor((player.posy+12.5) / 25);
    replayGameTick++


###
    Updating game logic
###

update = (modifier) =>
  # draw onto the debug bar
  $('#debugbar').html("inventory = #{player.inventory}, player.tilex = #{player.tilex}, player.tiley = #{player.tiley} \n
    health = #{player.health}, stamina = #{player.stamina}, hunger = #{player.hunger}, thirst = #{player.thirst}")
  # call update methods
  if(gamestarted || DEBUGMODE)
    player.update()
    updateScroll()



updateScroll = =>
   scrollxvel = scrollxvel * 0.92
   scrollyvel = scrollyvel * 0.92
   scrollx += scrollxvel
   scrollxvel += scrollxacc
   scrolly += scrollyvel
   scrollyvel += scrollyacc
   if (canvasWidth < fullWidth)
    if (scrollx < 0)
      scrollx = 0
      scrollxvel = 0
      scrollxacc = 0
    else if (mousex < canvasWidth * scrollRegion)
      scrollxacc = -scrollAccConst
    else if (scrollx > fullWidth - canvasWidth)
      scrollx = fullWidth - canvasWidth 
      scrollxvel = 0
      scrollxacc = 0
    else if (mousex > canvasWidth * (1 - scrollRegion))
      scrollxacc = scrollAccConst
    else 
      scrollxacc = 0
   else 
     scrollx = -(canvasWidth-fullWidth)/2  
   if (canvasHeight < fullHeight)
    if(scrolly < 0)
      scrolly = 0
      scrollyvel = 0
      scrollyacc = 0
    else if (mousey < canvasHeight * scrollRegion)
      scrollyacc = -scrollAccConst
    else if (scrolly > fullHeight - canvasHeight)
      scrolly = fullHeight - canvasHeight 
      scrollyvel = 0
      scrollyacc = 0
    else if (mousey > canvasHeight * (1 - scrollRegion))
      scrollyacc = scrollAccConst
    else 
      scrollyacc = 0
   else 
    scrolly = -(canvasHeight-fullHeight)/2
   mouseSquarex = Math.floor(mousex / tileWidth)
   mouseSquarey = Math.floor(mousey / tileHeight)

###
Main method loop 
###

count = 0
mainLoop = ->
  now = Date.now()
  delta = now - then_
  update delta / 1000
  render()
  then_ = now
  if count == 100
      player.decrement()
      count = 0
  count += 1
then_ = Date.now()

###
Replay loop
###

replayLoop = ->
  replayGameRender()
  replayGameUpdate()

mainLoopIntervalId = setInterval mainLoop, 10

DEBUGMODE = on

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

playerMovingLeft = false
playerMovingUp = false
playerMovingRight = false
playerMovingDown = false

filterReady = false
focusOnCanvas = true

actionMenuSelected = 0
actionMenuTotal = 0
actionMenuTileX = 0
actionMenuTileY = 0

filterImage = new Image()
filterImage.onload = => filterReady = true
filterImage.src = "#{assetDir}/filter.png"




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
    selectedAction.doFn(actionMenuTileX, actionMenuTileY)
  $('#actionmenu ul li#menuAction'+actionMenuSelected).toggleClass('selected')
    

inventoryPopup = ->
  #$('#inventorymenu').show()
  $('#inventorymenu').fadeToggle("fast")

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
      
      playerMovingLeft = false if (evt.keyCode == 37)     # left arrow key up -> playerMovingLeft becomes false
      playerMovingUp = false if (evt.keyCode == 38)       # up arrow key up -> playerMovingUp becomes false
      playerMovingRight = false if (evt.keyCode == 39)    # right arrow key up -> playerMovingRight becomes false
      playerMovingDown = false if (evt.keyCode == 40)     # down arrow key up -> playerMovingDown becomes false
      if(evt.keyCode == 73)
        inventoryPopup()

    else
      #This is NOT a canvas thing




  #key down event
    #set corresponding moving boolean to true
    #set all others to false
    
  $(document.documentElement).keydown (evt) ->
    if focusOnCanvas
      if (evt.keyCode == 37) # push left
        playerMovingLeft = true
        playerMovingUp = false
        playerMovingRight = false
        playerMovingDown = false
      if (evt.keyCode == 38) # push up
        playerMovingUp = true
        playerMovingLeft = false
        playerMovingRight = false
        playerMovingDown = false
      if (evt.keyCode == 39) # push right
        playerMovingRight = true
        playerMovingLeft = false
        playerMovingUp = false
        playerMovingDown = false
      if (evt.keyCode == 40) # push down
        playerMovingDown = true
        playerMovingLeft = false
        playerMovingUp = false
        playerMovingRight = false
    else
      actionMenuKeyDown(evt)



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



###
    Updating game logic
###

update = (modifier) =>
  if(gamestarted || DEBUGMODE)
    updatePlayerTiles()
    updatePlayerMovement()
    updateScroll()

updatePlayerTiles = =>
  # calculate the player's tile location from his pixel location
  oldTilex = player.tilex
  oldTiley = player.tiley
  player.tilex = Math.floor((player.posx+12.5) / 25);
  player.tiley = Math.floor((player.posy+12.5) / 25);

  # see if the tile has changed location
  if(oldTilex != player.tilex || oldTiley != player.tiley)
    # on player change square event
    player.statchange(map.getTile(player.tilex,player.tiley))
    sendPlayerData()
  $('#debugbar').html("inventory = #{player.inventory}, player.tilex = #{player.tilex}, player.tiley = #{player.tiley} \n
    health = #{player.health}, stamina = #{player.stamina}, hunger = #{player.hunger}, thirst = #{player.thirst}")


updatePlayerMovement = =>
  # work out the adjacent squares to the player
  playerRightSquare = Math.floor((player.posx+25)/25)
  playerLeftSquare = Math.floor((player.posx-1)/25)
  playerUpSquare = Math.floor((player.posy-1)/25)
  playerDownSquare = Math.floor((player.posy+25)/25)

  if `playerMovingLeft && map.inBounds(playerLeftSquare, player.tiley) && player.stamina > 0
      && !(map.inBounds(playerLeftSquare,player.tiley) && !map.getTile(playerLeftSquare,player.tiley).walkable)`
    player.posx = player.posx - player.speed  
  else if `playerMovingRight && map.inBounds(playerRightSquare, player.tiley) && player.stamina > 0
           && !(map.inBounds(playerRightSquare,player.tiley) && !map.getTile(playerRightSquare,player.tiley).walkable)`
    player.posx = player.posx + player.speed
  # if player not moving left or right, center it's horizontal position
  else
    player.posx = player.tilex*tileWidth
  
  # if player is moving up or down, update it's stored vertical position
  if `playerMovingUp && map.inBounds(player.tilex,playerUpSquare) && player.stamina > 0
      && !(map.inBounds(player.tilex,playerUpSquare) && !map.getTile(player.tilex,playerUpSquare).walkable)`
    player.posy = player.posy - player.speed
  else if `playerMovingDown && map.inBounds(player.tilex,playerDownSquare) && player.stamina > 0
      && !(map.inBounds(player.tilex,playerDownSquare) && !map.getTile(player.tilex,playerDownSquare).walkable)`  
    player.posy = player.posy + player.speed
  # if player not moving up or down, center it's vertical position
  else 
    player.posy = player.tiley*tileHeight


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
Main method
###

count = 0
main = ->
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
setInterval main, 10

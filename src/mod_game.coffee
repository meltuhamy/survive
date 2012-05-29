tileWidth = 25
tileHeight = 25

canvasWidth = 900
canvasHeight = 700

fullWidth = tileWidth*map.tileGrid.numcols
fullHeight = tileHeight*map.tileGrid.numrows


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

filterImage = new Image()
filterImage.onload = => filterReady = true
filterImage.src = 'filter.png'

#Initialisation events


makemenu = (x,y) ->
   menuactions = map.getTile(x, y).actions
   itemsactions = if map.noItem(x,y) then [] else map.getItem(x, y).actions
   menuactions = menuactions.concat(itemsactions)
   #displayNewMenu menuactions
   inputSelect = '<select id="actionSelection">'
   for menuaction in menuactions
    inputSelect = inputSelect.concat('<option value="'+menuaction.actionname+'">'+menuaction.actionname+'</option>')
   inputSelect = inputSelect.concat('</select>')
   #console.log 'Got here'
   displayNewMenu('Choose an action:', [inputSelect])

displayNewMenu = (menutitle, menuitems) ->
  console.log "Creating menu #{menutitle} with items:"
  console.log menuitems
  focusOnCanvas = false
  $('#dialog').bind( "dialogclose", (event, ui) -> focusOnCanvas = true)
  $('#dialog .content').empty()
  for item in menuitems
    $('#dialog .content').append item 
  
  $('#dialog').dialog( "option", "title", menutitle)
  $('#dialog').dialog( "open" )


inventoryPopup = ->
  #$('#inventorymenu').show()
  $('#inventorymenu').fadeToggle("fast")

$(document).ready ->

  #Dialogs
  $( "#dialog" ).dialog({
      autoOpen: false
  });

  # mouse move event within 'container' div

  $('#inventorymenu').hide()

  $('#actionSelection').keyup (evt) ->
    console.log 'Hit enter on actions'
    if(evt.keyCode == 13)
      alert('Did Action: '+$('#actionSelection:selected').html())
      $("#dialog").dialog('close')

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
      if (evt.keyCode == 68) #a
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
      #This is NOT a canvas thing


# executes once page has loaded

window.onload = =>

  # Create the kintetic stage
  window.stage = new Kinetic.Stage(
    container: "container"
    width: canvasWidth
    height: canvasHeight
  )

  # Map layer
  window.mapLayer = new Kinetic.Layer()

  # Hover select layer
  window.hoverSelectLayer = new Kinetic.Layer()
  window.hoverSelectBox = new Kinetic.Rect(
    fill: 'yellow'
    width: tileWidth
    height: tileHeight
    alpha: 0.6
  )
  window.hoverSelectLayer.add window.hoverSelectBox
  window.stage.add window.mapLayer
  window.stage.add window.hoverSelectLayer
  
###
    Loading resources
###

player = new Player()

###
    Drawing to canvas
###

vision1 = [{x:0,y:0}, {x:1,y:0}, {x:0,y:1}, {x:-1,y:0}, {x:0,y:-1}]
vision2 = [{x:0,y:0},{x:-1,y:-1},{x:0,y:-1},{x:1,y:-1},{x:1,y:0},{x:1,y:1},{x:0,y:1},{x:-1,y:1},{x:-1,y:0},{x:-2,y:0},{x:0,y:-2},{x:0,y:2},{x:2,y:0}]

render = =>
  mapContext = window.mapLayer.getContext() # get map
  mapContext.fillStyle = "#000000" 
  mapContext.fillRect(0,0,canvasWidth,canvasHeight) # fill map black


  # for every grid location
  for y in [0...map.tileGrid.numrows]
    for x in [0...map.tileGrid.numcols]
      # if the corresponding tile is loaded
      if (map.getTile(x,y).tileReady)
        # draw the image on the map in the position relative to map scroll
        mapContext.drawImage map.getTile(x,y).tileImage, x*tileWidth-scrollx, y*tileHeight-scrolly
        if (filterReady)
            mapContext.drawImage filterImage, x*tileWidth-scrollx, y*tileHeight-scrolly
            
  for v in vision2
    visionx = player.tilex+v.x
    visiony = player.tiley+v.y 
    if(map.inBounds(visionx,visiony))
      mapContext.drawImage map.getTile(visionx,visiony).tileImage, visionx*tileWidth-scrollx, visiony*tileHeight-scrolly
      if !map.noItem(visionx,visiony) then mapContext.drawImage map.getItem(visionx,visiony).tileImage, visionx*tileWidth-scrollx, visiony*tileHeight-scrolly

  oldTilex = player.tilex
  oldTiley = player.tiley
  player.tilex = Math.floor((player.posx+12.5) / 25);
  player.tiley = Math.floor((player.posy+12.5) / 25);
  if(oldTilex != player.tilex || oldTiley != player.tiley)
    player.statchange(map.getTile(player.tilex,player.tiley))
  $('#debugbar').html("inventory = #{player.inventory}, player.tilex = #{player.tilex}, player.tiley = #{player.tiley} \n
    health = #{player.health}, stamina = #{player.stamina}, hunger = #{player.hunger}, thirst = #{player.thirst}")
  
  window.hoverSelectBox.setX player.tilex*tileWidth - Math.floor(scrollx)
  window.hoverSelectBox.setY player.tiley*tileHeight - Math.floor(scrolly)


  #window.hoverSelectBox.setX Math.floor((scrollx + mousex) / 25)*25 - Math.floor(scrollx)
  #window.hoverSelectBox.setY Math.floor((scrolly + mousey) / 25)*25 - Math.floor(scrolly)

  window.hoverSelectLayer.draw()

  #console.log("hoverSelectBox x: #{window.hoverSelectBox.getX()} y:#{window.hoverSelectBox.getY()}")

  mapContext.drawImage player.playerImage, player.posx-scrollx, player.posy-scrolly if player.imgReady

  # if player is moving left or right, update it's stored horizontal position
  playerRightSquare = Math.floor((player.posx+25)/25)
  playerLeftSquare = Math.floor((player.posx-1)/25)
  playerUpSquare = Math.floor((player.posy-1)/25)
  playerDownSquare = Math.floor((player.posy+25)/25)

  if `playerMovingLeft && map.inBounds(playerLeftSquare, player.tiley)
      && !(map.inBounds(playerLeftSquare,player.tiley) && !map.getTile(playerLeftSquare,player.tiley).walkable)
      && !(map.inBounds(playerLeftSquare,player.tiley) && player.stamina < map.getTile(playerLeftSquare,player.tiley).stamina_cost)`
    player.posx = player.posx - player.speed  
  else if `playerMovingRight && map.inBounds(playerRightSquare, player.tiley)
           && !(map.inBounds(playerRightSquare,player.tiley) && !map.getTile(playerRightSquare,player.tiley).walkable)
           && !(map.inBounds(playerRightSquare,player.tiley) && player.stamina < map.getTile(playerRightSquare,player.tiley).stamina_cost)`
    player.posx = player.posx + player.speed
  # if player not moving left or right, center it's horizontal position
  else
    player.posx = player.tilex*tileWidth
  
  # if player is moving up or down, update it's stored vertical position
  if `playerMovingUp && map.inBounds(player.tilex,playerUpSquare)
      && !(map.inBounds(player.tilex,playerUpSquare) && !map.getTile(player.tilex,playerUpSquare).walkable)
      && !(map.inBounds(player.tilex,playerUpSquare) && player.stamina < map.getTile(player.tilex,playerUpSquare).stamina_cost)`
    player.posy = player.posy - player.speed
  else if `playerMovingDown && map.inBounds(player.tilex,playerDownSquare)
      && !(map.inBounds(player.tilex,playerDownSquare) && !map.getTile(player.tilex,playerDownSquare).walkable)
      && !(map.inBounds(player.tilex,playerDownSquare) && player.stamina < map.getTile(player.tilex,playerDownSquare).stamina_cost)`  
    player.posy = player.posy + player.speed
  # if player not moving up or down, center it's vertical position
  else 
    player.posy = player.tiley*tileHeight
     
  #update the hover select box position
  #debugText.setText("rightwalkable = #{map.getTile(player.tilex+1,player.tiley).walkable}, rightwalkablepixel = #{player.posx+25}")


  


###
    Updating game logic
###

update = (modifier) -> updateScroll()
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

main = ->
  now = Date.now()
  delta = now - then_
  update delta / 1000
  render()
  then_ = now
then_ = Date.now()
setInterval main, 50

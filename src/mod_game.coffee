tileWidth = 25
tileHeight = 25

canvasWidth = 1000
canvasHeight = 1000

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

#Initialisation events


$(document).ready ->

  # mouse move event within 'container' div

  $('#container').mousemove (evt) ->
    offset = $(@).offset()    # not quite sure what @ refers to, but this gets an offset
    mousex = Math.floor(evt.pageX - offset.left)    # sets mousex var to new mouse position
    mousey = Math.floor(evt.pageY - offset.top)     # sets mousey var to new mouse position
    #console.log("x,y : #{mousex},#{mousey}")

  # key up event

  $(document.documentElement).keyup (evt) ->
    #alert ("Key pressed! Value: #{evt.keyCode}") 
    if (evt.keyCode == 87) #w pressed
      map.getTile(player.playerSquarex, player.playerSquarey-1).actions[0].doFn(player.playerSquarex, player.playerSquarey-1)
      if !map.noItem(player.playerSquarex, player.playerSquarey-1) then map.getItem(player.playerSquarex, player.playerSquarey-1).actions[0].doFn(player.playerSquarex, player.playerSquarey-1)
    if (evt.keyCode == 83) #s
      map.getTile(player.playerSquarex, player.playerSquarey+1).actions[0].doFn(player.playerSquarex,player.playerSquarey+1)
      if !map.noItem(player.playerSquarex, player.playerSquarey+1) then map.getItem(player.playerSquarex, player.playerSquarey+1).actions[0].doFn(player.playerSquarex,player.playerSquarey+1)
    if (evt.keyCode == 65) #a
      map.getTile(player.playerSquarex-1, player.playerSquarey).actions[0].doFn(player.playerSquarex-1, player.playerSquarey)
      if !map.noItem(player.playerSquarex-1, player.playerSquarey) then map.getItem(player.playerSquarex-1, player.playerSquarey).actions[0].doFn(player.playerSquarex-1, player.playerSquarey)
    if (evt.keyCode == 68) #d 
      map.getTile(player.playerSquarex+1, player.playerSquarey).actions[0].doFn(player.playerSquarex+1, player.playerSquarey)
      if !map.noItem(player.playerSquarex+1, player.playerSquarey) then map.getItem(player.playerSquarex+1, player.playerSquarey).actions[0].doFn(player.playerSquarex+1, player.playerSquarey)
    playerMovingLeft = false if (evt.keyCode == 37)     # left arrow key up -> playerMovingLeft becomes false
    playerMovingUp = false if (evt.keyCode == 38)       # up arrow key up -> playerMovingUp becomes false
    playerMovingRight = false if (evt.keyCode == 39)    # right arrow key up -> playerMovingRight becomes false
    playerMovingDown = false if (evt.keyCode == 40)     # down arrow key up -> playerMovingDown becomes false
    



  #key down event
    #set corresponding moving boolean to true
    #set all others to false
    
  $(document.documentElement).keydown (evt) ->
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

  # Debug text layer
  window.debugLayer = new Kinetic.Layer()
  window.debugText = new Kinetic.Text(
    x: 10,
    y: 10,
    fontSize: 12,
    fontFamily: "Calibri",
    textFill: "red",
    align: "left",
    verticalAlign: "middle"
  )

  window.debugLayer.add window.debugText
  window.stage.add window.mapLayer
  window.stage.add window.hoverSelectLayer
  window.stage.add window.debugLayer
  


###
    Loading resources
###

player = new Player()

###
    Drawing to canvas
###

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
        if !map.noItem(x,y) then mapContext.drawImage map.getItem(x,y).tileImage, x*tileWidth-scrollx, y*tileHeight-scrolly

  #window.hoverSelectBox.setX Math.floor((scrollx + mousex) / 25)*25 - Math.floor(scrollx)
  #window.hoverSelectBox.setY Math.floor((scrolly + mousey) / 25)*25 - Math.floor(scrolly)

  window.hoverSelectLayer.draw()

  #console.log("hoverSelectBox x: #{window.hoverSelectBox.getX()} y:#{window.hoverSelectBox.getY()}")

  mapContext.drawImage player.playerImage, player.playerx-scrollx, player.playery-scrolly if player.imgReady

  # if player is moving left or right, update it's stored horizontal position
  if `playerMovingLeft 
      && map.getTile(player.playerSquarex-1,player.playerSquarey).walkable 
      && map.getTile(player.playerSquarex-1,player.playerSquarey).stamina_cost <= player.stamina`
    player.playerx = player.playerx - player.speed
  else if `playerMovingRight 
           && map.getTile(player.playerSquarex+1,player.playerSquarey).walkable 
           && map.getTile(player.playerSquarex+1,player.playerSquarey).stamina_cost <= player.stamina`
    player.playerx = player.playerx + player.speed
  # if player not moving left or right, center it's horizontal position
  else
    player.playerx = player.playerSquarex*tileWidth
  
  # if player is moving up or down, update it's stored vertical position
  if `playerMovingUp 
      && map.getTile(player.playerSquarex,player.playerSquarey-1).walkable 
      && map.getTile(player.playerSquarex,player.playerSquarey-1).stamina_cost <= player.stamina`
    player.playery = player.playery - player.speed
  else if `playerMovingDown 
           && map.getTile(player.playerSquarex,player.playerSquarey+1).walkable 
           && map.getTile(player.playerSquarex,player.playerSquarey+1).stamina_cost <= player.stamina`
    player.playery = player.playery + player.speed
  # if player not moving up or down, center it's vertical position
  else 
    player.playery = player.playerSquarey*tileHeight
    
  #update the hover select box position

  oldplayerSquarex = player.playerSquarex
  oldplayerSquarey = player.playerSquarey
  player.playerSquarex = Math.floor((player.playerx+12.5) / 25);
  player.playerSquarey = Math.floor((player.playery+12.5) / 25);
  if(oldplayerSquarex != player.playerSquarex || oldplayerSquarey != player.playerSquarey)
    player.statchange(map.getTile(player.playerSquarex,player.playerSquarey))
  debugText.setText("inventory = #{player.inventory}, player.playerSquarex = #{player.playerSquarex}, player.playerSquarey = #{player.playerSquarey} \n
    health = #{player.health}, stamina = #{player.stamina}, hunger = #{player.hunger}, thirst = #{player.thirst}")
  window.debugLayer.draw()
  window.hoverSelectBox.setX player.playerSquarex*tileWidth - Math.floor(scrollx)
  window.hoverSelectBox.setY player.playerSquarey*tileHeight - Math.floor(scrolly)


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
setInterval main, 1

# Modularised game

# the map array


###

|
v
array of objects
|
v
long string
|
v
db
|
string
|
v
arrayobjects


.________________________________________
| playerid      |  location |  other stuff  |
----------------------------|------------
| name            |  "............"     |
----------------------------|------------
###

class Map
	constructor: (@mapArray, @numrows, @numcols) ->
	mapArray: []
	numrows: 0
	numcols: 0

	gridIndex: (x,y) -> y*@numcols + x
	getElement: (row,col) -> @mapArray[@gridIndex(row,col)]
	setElement: (row,col,item) -> @mapArray[@gridIndex(row,col)] = item


map0 = [0, 3, 4, 0, 0, 0, 0, 0, 4, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 4, 0,
        0, 0, 0, 2, 2, 2, 2, 2, 4, 0,
        0, 0, 0, 2, 1, 4, 4, 4, 2, 0,
        1, 0, 0, 2, 2, 4, 2, 2, 2, 0,
        0, 0, 0, 0, 0, 4, 0, 0, 0, 0,
        0, 0, 3, 3, 0, 0, 4, 0, 0, 0,
        0, 3, 0, 0, 3, 0, 0, 4, 0, 0,
        3, 0, 0, 0, 0, 3, 0, 4, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 4, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 4, 0,
        0, 0, 0, 2, 2, 2, 2, 2, 4, 0,
        0, 0, 0, 2, 1, 4, 4, 4, 2, 0,
        0, 0, 0, 2, 2, 4, 2, 2, 2, 0,
        0, 0, 0, 0, 0, 4, 0, 0, 0, 0,
        0, 0, 3, 3, 0, 0, 4, 0, 0, 0,
        0, 3, 0, 0, 3, 0, 0, 4, 0, 0,
        3, 0, 0, 0, 0, 3, 0, 4, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 4, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 4, 0,
        0, 0, 0, 2, 2, 2, 2, 2, 4, 0,
        0, 0, 0, 2, 1, 4, 4, 4, 2, 0,
        0, 0, 0, 2, 2, 4, 2, 2, 2, 0,
        0, 0, 0, 0, 0, 4, 0, 0, 0, 0,
        0, 0, 3, 3, 0, 0, 4, 0, 0, 0,
        0, 3, 0, 0, 3, 0, 0, 4, 0, 0,
        3, 0, 0, 0, 0, 3, 0, 4, 0, 0,
        3, 0, 0, 0, 0, 3, 0, 4, 0, 0,
        3, 0, 0, 0, 0, 3, 0, 4, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 4, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 4, 0,
        0, 0, 0, 2, 2, 2, 2, 2, 4, 0,
        0, 0, 0, 2, 1, 4, 4, 4, 2, 0,
        0, 0, 0, 2, 2, 4, 2, 2, 2, 0,
        0, 0, 0, 0, 0, 4, 0, 0, 0, 0,
        0, 0, 3, 3, 0, 0, 4, 0, 0, 0,
        0, 3, 0, 0, 3, 0, 0, 4, 0, 0,
        3, 0, 0, 0, 0, 3, 0, 4, 0, 0,
        0, 0, 0, 2, 2, 4, 2, 2, 2, 0,
        0, 0, 0, 0, 0, 4, 0, 0, 0, 0,
        0, 0, 3, 3, 0, 0, 4, 0, 0, 0,
        0, 3, 0, 0, 3, 0, 0, 4, 0, 0,
        3, 0, 0, 0, 0, 3, 0, 4, 0, 0,
        3, 0, 0, 0, 0, 3, 0, 4, 0, 0,
        3, 0, 0, 0, 0, 3, 0, 4, 0, 0]

map = new Map(map0, 15, 30)

tileWidth = 25
tileHeight = 25

canvasWidth = 400
canvasHeight = 300

fullWidth = tileWidth*map.numcols
fullHeight = tileHeight*map.numrows

mousex = 0
mousey = 0
mouseSquarex = 0
mouseSquarey = 0

playerx = 0
playery = 0
playerspeed = 0.8

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
    text: "Simple Text",
    fontSize: 12,
    fontFamily: "Calibri",
    textFill: "green",
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

files = ["grass.png", "fire.png", "hill.png", "stone.png", "water.png"]

class Tile
  constructor: (src) -> 
    @tileImage = new Image()
    @tileImage.onload = => @tileReady = true
    @tileImage.src = src
  tileReady: false
  
tileArray = {}

for currentFile in [0...files.length]
    tileArray[currentFile] = new Tile(files[currentFile])

class Player
  constructor: -> 
    @playerImage = new Image()
    @playerImage.onload = => @imgReady = true
    @playerImage.src = "sprite.png"
  imgReady: false

player = new Player()

###
    Drawing to canvas
###

render = =>
  mapContext = window.mapLayer.getContext() # get map
  mapContext.fillStyle = "#000000" 
  mapContext.fillRect(0,0,canvasWidth,canvasHeight) # fill map black


  # for every grid location
  for y in [0...map.numrows]
    for x in [0...map.numcols]
      # if the corresponding tile is loaded
      if (tileArray[map.getElement(x,y)].tileReady)
        # draw the image on the map in the position relative to map scroll
        mapContext.drawImage tileArray[map.getElement(x,y)].tileImage, x*tileWidth-scrollx, y*tileHeight-scrolly

  #window.hoverSelectBox.setX Math.floor((scrollx + mousex) / 25)*25 - Math.floor(scrollx)
  #window.hoverSelectBox.setY Math.floor((scrolly + mousey) / 25)*25 - Math.floor(scrolly)

  window.hoverSelectLayer.draw()

  #console.log("hoverSelectBox x: #{window.hoverSelectBox.getX()} y:#{window.hoverSelectBox.getY()}")

  mapContext.drawImage player.playerImage, playerx-scrollx, playery-scrolly if player.imgReady

  # if player is moving left or right, update it's stored horizontal position
  if playerMovingLeft 
    playerx = playerx - playerspeed
  else if playerMovingRight 
    playerx = playerx + playerspeed
  # if player not moving left or right, center it's horizontal position
  else
    playerx = Math.floor((playerx+12.5)/tileWidth)*tileWidth
  
  # if player is moving up or down, update it's stored vertical position
  if playerMovingUp 
    playery = playery - playerspeed
  else if playerMovingDown 
    playery = playery + playerspeed
  # if player not moving up or down, center it's vertical position
  else 
    playery = Math.floor((playery+12.5)/tileHeight)*tileHeight
    
  #update the hover select box position

  window.hoverSelectBox.setX Math.floor((playerx+12.5)/tileWidth)*tileWidth - Math.floor(scrollx)
  window.hoverSelectBox.setY Math.floor((playery+12.5)/tileHeight)*tileHeight - Math.floor(scrolly)
  debugText.setText("playerx = #{playerx}, playery = #{playery}")
  window.debugLayer.draw()


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

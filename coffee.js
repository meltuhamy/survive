
map0 = [0, 0, 0, 0, 0, 0, 0, 0, 4, 0,
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

numrows = 15
numcols = 30

canvasWidth = 400
canvasHeight = 400

fullWidth = 25*numcols
fullHeight = 25*numrows

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

gridIndex = (x,y) -> y*numcols + x

###
Initialisation events
###


$(document).ready ->
  $('#container').mousemove (evt) ->
    offset = $(@).offset(); 
    mousex = Math.floor(evt.pageX - offset.left);  
    mousey = Math.floor(evt.pageY - offset.top);
    console.log("x,y : #{mousex},#{mousey}")


window.onload = ->
  window.stage = new Kinetic.Stage(
    container: "container"
    width: canvasWidth
    height: canvasHeight
  )
  window.mapLayer = new Kinetic.Layer()
  window.stage.add mapLayer


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



###
Drawing to canvas
###

render = ->
  mapContext = window.mapLayer.getContext()
  mapContext.fillStyle = "#000000";
  mapContext.fillRect(0,0,canvasWidth,canvasHeight);
  for y in [0...numrows]
    for x in [0...numcols]
      if (tileArray[map0[gridIndex(x,y)]].tileReady)
        mapContext.drawImage tileArray[map0[gridIndex(x,y)]].tileImage, x*25-scrollx, y*25-scrolly


###
Updating game logic
###

update = (modifier) -> updateScroll()
updateScroll = ->
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
   mouseSquarex = Math.floor((scrollx + mousex) / 25)
   mouseSquarey = Math.floor((scrolly + mousey) / 25)


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



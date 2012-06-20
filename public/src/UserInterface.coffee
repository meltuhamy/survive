
actionMenuVisible = false
actionMenuSelected = 0
actionMenuTotal = 0
actionMenuTileX = 0
actionMenuTileY = 0

inventoryactionMenuVisible = false
inventoryactionMenuSelected = 0
inventoryactionMenuTotal = 0
inventoryactionMenuChoosenSlot = 0

textImages = {}
sources = {
  gameover: "game-over-text.png",
  fight: "fight-text.png",
  youwin: "you-win-text.png",
  youlose: "you-lose-text.png",
  yousuck: "you-suck-text.png"
};
fightText = null
youwinText = null
youloseText = null


createTextEffects = (stage) =>
  @textUiLayer = new Kinetic.Layer()
  fightText = new Kinetic.Image({
    image: textImages.fight
  })
  youwinText = new Kinetic.Image({
    alpha: 0,
    image: textImages.youwin
  })
  youloseText = new Kinetic.Image({
    alpha: 0,
    image: textImages.youlose
  })
  @textUiLayer.add fightText
  @textUiLayer.add youwinText
  @textUiLayer.add youloseText
  stage.add @textUiLayer


  
loadImages = (sources) ->
  loadedImages = 0
  numImages = 0
  for src of sources
    numImages++
  for src of sources
    textImages[src] = new Image()
    textImages[src].onload = ->
      #callback(textImages)  if ++loadedImages >= numImages
    textImages[src].src = Settings.uiDir + "/" + sources[src]


loadImages(sources);


showFightText = =>
  #console.log (Settings.canvasWidth - textImages.fight.width) / 2
  fightText.setAttrs({
    x: Settings.canvasWidth / 2,
    y: Settings.canvasHeight / 2,
    alpha: 0,
    scale: {
      x: 4,
      y: 4
    },
    centerOffset: [textImages.fight.width / 2, textImages.fight.height / 2]
  })
  fightText.transitionTo({
    scale: {
      x: 1,
      y: 1
    },
    duration: 0.5,
    alpha: 1,
    easing: 'elastic-ease-out',
    callback: ->
      fightText.transitionTo({
        alpha: 0,
        duration: 2
      })
  })



showYouWinText = ->
  youwinText.setAttrs({
    x: Settings.canvasWidth / 2 - 150,
    y: Settings.canvasHeight / 2,
    alpha: 0,
    centerOffset: [textImages.youwin.width / 2, textImages.youwin.height / 2]
  })
  youwinText.transitionTo({
    x: Settings.canvasWidth / 2
    y: Settings.canvasHeight / 2
    duration: 1
    alpha: 1,
    easing: 'elastic-ease-out',
  });


showYouLoseText = ->
  youloseText.setAttrs({
    x: Settings.canvasWidth / 2 - 50,
    y: Settings.canvasHeight / 2,
    alpha: 0,
    centerOffset: [textImages.youlose.width / 2, textImages.youlose.height / 2]
  })
  youloseText.transitionTo({
    x: Settings.canvasWidth / 2,
    y: Settings.canvasHeight / 2,
    duration: 2,
    alpha: 1,
    easing: 'ease-out',
  })




# Makes the action menu for given coordinates
makemenu = (x,y) ->
   menuactions = map.getActions(x,y)    #first we get all actions available at given coordinates
   inputSelect = ''
   if (menuactions.length == 0) then return
   for i in [0...menuactions.length]
     inputSelect = inputSelect.concat('<li>'+menuactions[i].actionname+'</li>')
   $('#actionmenu').css('top', y*Settings.tileHeight-Camera.scrolly)
   $('#actionmenu').css('left', x*Settings.tileWidth-Camera.scrollx)
   actionMenuSelected = 0
   actionMenuTileX = x
   actionMenuTileY = y
   actionMenuTotal = menuactions.length
   PlayerInput.focusOnCanvas = false
   $('#actionlist').html inputSelect 
   $('#actionlist li').first().toggleClass('selected')
   $('#actionmenu').fadeIn("fast")
   $('#inventoryactionmenu').fadeOut("fast")
   actionMenuVisible = true
   inventoryactionMenuVisible = false

# Makes the inventoryaction menu for given coordinates
inventorymakemenu = (itemIndex) ->
   $('#inventorySlots li').eq(itemIndex).css('box-shadow','inset 0 0 10px red')
   inventorymenuactions = (map.getItemFromNumber Game.player.inventory[itemIndex]).inventoryActions
   #console.log inventorymenuactions
   inventoryinputSelect = ''
   if (inventorymenuactions.length == 0) then return
   for i in [0...inventorymenuactions.length]
     inventoryinputSelect = inventoryinputSelect.concat('<li>'+inventorymenuactions[i].actionname+'</li>')
   $('#inventoryactionmenu').css('left', $('#inventorySlots li').eq(itemIndex).position().left)
   inventoryactionMenuSelected = 0
   inventoryactionMenuChoosenSlot = itemIndex
   inventoryactionMenuTotal = inventorymenuactions.length
   PlayerInput.focusOnCanvas = false
   $('#inventoryactionlist').html inventoryinputSelect
   $('#inventoryactionlist li').first().toggleClass('selected')
   $('#inventoryactionmenu').fadeIn("fast")
   $('#actionmenu').fadeOut("fast")
   inventoryactionMenuVisible = true
   actionMenuVisible = false


actionMenuKeyDown = (evt) ->
  if(!actionMenuVisible) then return
  $('#actionlist li').eq(actionMenuSelected).toggleClass('selected')
  if(evt.keyCode == KEYCODE.uparrow)
    #console.log "Pressed uparrow on actionmenu"
    actionMenuSelected = (actionMenuSelected-1+actionMenuTotal) % actionMenuTotal
  else if(evt.keyCode == KEYCODE.downarrow)
    #console.log "Pressed downarrow on actionmenu"
    actionMenuSelected = (actionMenuSelected+1) % actionMenuTotal
  else if(evt.keyCode == KEYCODE.enter)
    #console.log "Pressed enter on actionmenu"
    PlayerInput.focusOnCanvas = true
    actions = map.getActions(actionMenuTileX, actionMenuTileY)
    selectedAction = actions[actionMenuSelected]
    $('#actionmenu').fadeOut("fast")
    $('#actionlist').empty()
    actionmenuVisible = false
    #console.log "UI.coffee actionmenuVisible=#{actionmenuVisible}"
    selectedAction.doFn(actionMenuTileX, actionMenuTileY)
  else if(evt.keyCode == KEYCODE.escape)
    #console.log "Pressed escape on actionmenu"
    PlayerInput.focusOnCanvas = true
    $('#actionmenu').fadeOut("fast")
    actionmenuVisible = false
  $('#actionlist li').eq(actionMenuSelected).toggleClass('selected')

inventoryactionMenuKeyDown = (evt) ->
  if(!inventoryactionMenuVisible) then return
  $('#inventoryactionlist li').eq(inventoryactionMenuSelected).toggleClass('selected')
  if(evt.keyCode == KEYCODE.uparrow)
    inventoryactionMenuSelected = (inventoryactionMenuSelected-1+inventoryactionMenuTotal) % inventoryactionMenuTotal
  else if(evt.keyCode == KEYCODE.downarrow)
    inventoryactionMenuSelected = (inventoryactionMenuSelected+1) % inventoryactionMenuTotal
  else if(evt.keyCode == KEYCODE.enter)
    PlayerInput.focusOnCanvas = true
    inventoryactions = (map.getItemFromNumber Game.player.inventory[inventoryactionMenuChoosenSlot]).inventoryActions
    inventoryselectedAction = inventoryactions[inventoryactionMenuSelected]
    $('#inventoryactionmenu').fadeOut("fast")
    $('#inventoryactionlist').empty()
    $('#inventorySlots li').eq(inventoryactionMenuChoosenSlot).css('box-shadow','inset 0 0 10px #000000')
    inventoryactionmenuVisible = false
    inventoryselectedAction.doFn(inventoryactionMenuChoosenSlot)
  else if(evt.keyCode == KEYCODE.escape)
    PlayerInput.focusOnCanvas = true
    $('#inventoryactionmenu').fadeOut("fast")
    $('#inventorySlots li').eq(inventoryactionMenuChoosenSlot).css('box-shadow','inset 0 0 10px #000000')
    inventoryactionmenuVisible = false
  $('#inventoryactionlist li').eq(inventoryactionMenuSelected).toggleClass('selected')

reloadPage = ->
  window.location.reload()
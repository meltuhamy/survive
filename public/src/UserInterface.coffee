
actionMenuVisible = false
actionMenuSelected = 0
inventoryactionMenuSelected = 0
actionMenuTotal = 0
actionMenuTileX = 0
actionMenuTileY = 0

inventoryActionSelected = 0


# Makes the action menu for given coordinates
makemenu = (x,y) ->
   menuactions = map.getActions(x,y)    #first we get all actions available at given coordinates
   inputSelect = ''
   if (menuactions.length == 0) then return
   for i in [0...menuactions.length]
     inputSelect = inputSelect.concat('<li id="menuAction'+i+'">'+menuactions[i].actionname+'</li>')
   $('#actionmenu').css('top', y*Settings.tileHeight-Camera.scrolly)
   $('#actionmenu').css('left', x*Settings.tileWidth-Camera.scrollx)
   actionMenuSelected = 0
   actionMenuTileX = x
   actionMenuTileY = y
   actionMenuTotal = menuactions.length
   PlayerInput.focusOnCanvas = false
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
    PlayerInput.focusOnCanvas = true
    actions = map.getActions(actionMenuTileX, actionMenuTileY)
    selectedAction = actions[actionMenuSelected]
    $('#actionmenu').fadeOut("fast")
    actionmenuVisible = false
    selectedAction.doFn(actionMenuTileX, actionMenuTileY)
  else if(evt.keyCode == 27)
    PlayerInput.focusOnCanvas = true
    $('#actionmenu').fadeOut("fast")
    actionmenuVisible = false
  $('#actionmenu ul li#menuAction'+actionMenuSelected).toggleClass('selected')

# Makes the action menu for given coordinates
makeInventoryMenu = (itemIndex) ->
   itemNo = Game.player.inventory[itemIndex]
   itemObj = map.getItemFromNumber itemNo
   inventorymenuactions = itemObj.inventoryActions
   inputSelect = ''
   if (inventorymenuactions.length == 0) then return
   for i in [0...inventorymenuactions.length]
     inputSelect = inputSelect.concat('<li id="itemAction'+i+'">'+inventorymenuactions[i].actionname+'</li>')
   $('#inventoryactionmenu').css('left', $('#inventorySlots li').eq(itemIndex).position().left)
   inventoryactionMenuSelected = 0
   inventoryActionMenuTotal = inventorymenuactions.length
   PlayerInput.focusOnCanvas = false
   $('#inventoryactionmenu ul').html inputSelect 
   $('#inventoryactionmenu ul li#itemAction0').toggleClass('selected')
   $('#inventoryactionmenu').fadeIn("fast")



pushInventory = (itemNo) ->
  itemObj = map.getItemFromNumber(itemNo)
  imgSource = itemObj.tileImage.src
  $('#inventorySlots').append("<li class=\"item#{itemNo}\"><img src=\"#{imgSource}\"></img></li>")



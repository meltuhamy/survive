class PlayerInput
  @mousex: 0
  @mousey: 0
  @mouseSquarex: 0
  @mouseSquarey: 0
  @focusOnCanvas: true

  @onKeyUp: (evt) =>
    if @focusOnCanvas && Game.player.alive
      if (evt.keyCode == 87) #w pressed
        makemenu(Game.player.tilex, Game.player.tiley-1)
      if (evt.keyCode == 83) #s pressed
        makemenu(Game.player.tilex, Game.player.tiley+1)
      if (evt.keyCode == 65) #a
        makemenu(Game.player.tilex-1, Game.player.tiley)
      if (evt.keyCode == 68) #d
        makemenu(Game.player.tilex+1, Game.player.tiley)
      if (evt.keyCode == 49)
        makeInventoryMenu(0)
      if(evt.keyCode == 73)
        inventoryPopup()
      Game.player.onKeyUp(evt)

  @onKeyDown: (evt) =>
  	if @focusOnCanvas && Game.player.alive
      Game.player.onKeyDown(evt)
      if(evt.keyCode == 82) # press r
        replayGameTick = 0
        socket.emit "clientSendingReplayRequest", {roomNumber: Game.player.roomNumber}
    else
      if actionMenuVisible
        actionMenuKeyDown(evt)
      else
        inventoryActionKeyDown(evt)

  @onMouseMove: (evt, elem) =>
    # mouse move event within 'container' div
    offset = $(elem).offset()
    @mousex = Math.floor(evt.pageX - offset.left)    # sets mousex var to new mouse position
    @mousey = Math.floor(evt.pageY - offset.top)     # sets mousey var to new mouse position

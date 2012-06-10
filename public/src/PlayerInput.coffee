
class PlayerInput
  @mousex: 0
  @mousey: 0
  @mouseSquarex: 0
  @mouseSquarey: 0
  @focusOnCanvas: true

  @onKeyUp: (evt) =>
    if @focusOnCanvas && Game.player.alive
      if (evt.keyCode == KEYCODE.w) #w pressed
        makemenu(Game.player.tilex, Game.player.tiley-1)
      if (evt.keyCode == KEYCODE.s) #s pressed
        makemenu(Game.player.tilex, Game.player.tiley+1)
      if (evt.keyCode == KEYCODE.a) #a
        makemenu(Game.player.tilex-1, Game.player.tiley)
      if (evt.keyCode == KEYCODE.d) #d
        makemenu(Game.player.tilex+1, Game.player.tiley)
      if (KEYCODE.num1 <= evt.keyCode <= KEYCODE.num6)
        inventorymakemenu(evt.keyCode - KEYCODE.num1)
      Game.player.onKeyUp(evt)

  @onKeyDown: (evt) =>
  	if @focusOnCanvas && Game.player.alive
      Game.player.onKeyDown(evt)
      if(evt.keyCode == KEYCODE.r) # press r
        replayGameTick = 0
        socket.emit "clientSendingReplayRequest", {roomNumber: Game.player.roomNumber}
    else
      if actionMenuVisible
        actionMenuKeyDown(evt)
      else
        inventoryactionMenuKeyDown(evt)

  @onMouseMove: (evt, elem) =>
    # mouse move event within 'container' div
    offset = $(elem).offset()
    @mousex = Math.floor(evt.pageX - offset.left)    # sets mousex var to new mouse position
    @mousey = Math.floor(evt.pageY - offset.top)     # sets mousey var to new mouse position

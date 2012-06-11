directions = [{x:0,y:-1},{x:1,y:0},{x:0,y:1},{x:-1,y:0}]

class PlayerInput
  @mousex: 0
  @mousey: 0
  @mouseSquarex: 0
  @mouseSquarey: 0
  @focusOnCanvas: true

  @onKeyUp: (evt) =>
    if @focusOnCanvas && Game.player.alive
      if (evt.keyCode == KEYCODE.action)
        actionx = Game.player.tilex + directions[Game.player.direction].x
        actiony = Game.player.tiley + directions[Game.player.direction].y
        makemenu actionx, actiony
      else if (evt.keyCode == KEYCODE.attack)
        Game.player.sendAttack()
        #NetworkClient.sendAttackData(3)
      else
        Game.player.onKeyUp(evt)

  @onKeyDown: (evt) =>
  	if @focusOnCanvas && Game.player.alive
      if(evt.keyCode == KEYCODE.r) # press r
        replayGameTick = 0
        socket.emit "clientSendingReplayRequest", {roomNumber: Game.player.roomNumber}
      else
        Game.player.onKeyDown(evt)
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

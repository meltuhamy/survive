class PlayerInput
  @mousex: 0
  @mousey: 0
  @mouseSquarex: 0
  @mouseSquarey: 0
  @focusOnCanvas: true

  #@focus:0
  #@focusEnum = {player:0, actionmenu:1, inventoryactionmenu:2}

  @onKeyUp: (evt) =>
    if @focusOnCanvas && Game.player.alive
      if (evt.keyCode == KEYCODE.action)
        Game.player.setNotMovingInAnyDir()
        actionx = Game.player.tilex + Game.player.directionDeltas[Game.player.direction].x
        actiony = Game.player.tiley + Game.player.directionDeltas[Game.player.direction].y
        makemenu actionx, actiony
      else if (KEYCODE.num1 <= evt.keyCode <= KEYCODE.num6)
        inventorymakemenu(evt.keyCode - KEYCODE.num1)
      else if (evt.keyCode == KEYCODE.attack)
        Game.player.sendAttack()
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
        console.log "create inventory menu"
        Game.player.setNotMovingInAnyDir()
        inventoryactionMenuKeyDown(evt)

  @onMouseMove: (evt, elem) =>
    # mouse move event within 'container' div
    offset = $(elem).offset()
    @mousex = Math.floor(evt.pageX - offset.left)    # sets mousex var to new mouse position
    @mousey = Math.floor(evt.pageY - offset.top)     # sets mousey var to new mouse position
    #console.log "Mousex, mousey #{@mousex},#{@mousey}"

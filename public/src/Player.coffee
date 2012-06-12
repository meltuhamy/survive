class Player
  id: -1
  roomNumber: -1
  stats: {health: 100, stamina:100, hunger:100, thirst:100}
  alive: true
  inventory: []
  # Position
  posx: 0
  posy: 0
  tilex: 0
  tiley: 0
  oldTilex: 0
  oldTiley: 0
  playerImage: null
  # Movement
  speed: 2.8
  direction: 0
  playerMovingInDir: [false, false, false, false]
  directions: {up:0, right:1, down:2, left:3}
  directionDeltas: [{x:0,y:-1},{x:1,y:0},{x:0,y:1},{x:-1,y:0}]

  constructor: (@id, @roomNumber) -> 
    @spriteNumber = Math.floor(Math.random() * 9)
    baseSource = "#{Settings.spriteDir}#{@spriteNumber}/sprite"
    @playerImages = [new Image(), new Image(), new Image(), new Image()]
    for x in [0..3]
      @playerImages[x].src = baseSource + x + ".png"
      @playerImages[x].isReady = false
      @playerImages[x].index = x
      @playerImages[x].onload = ->
        @isReady = true
    @turn(@directions.down)
    @changeHealth(10)
    @changeStamina(100)
    @changeHunger(100)
    @changeThirst(100)


  #imgReady: -> @playerImages[0].isReady && @playerImages[1].isReady && @playerImages[2].isReady && @playerImages[3].isReady
  imgReady: -> @playerImage.isReady


  statsLimit: (amt) ->
    if(amt < 0) then return 0
    if(amt > 100) then return 100
    return amt

  changeHealth: (amt) ->
    @stats.health = @statsLimit(amt)
    if(@stats.health == 0) then @setDead()
    # change health bar
    $('#healthBar').css('width', "#{@stats.health}%")

  changeStamina: (amt) ->
    @stats.stamina = @statsLimit(amt)
    # change stamina bar
    $('#staminaBar').css('width', "#{@stats.stamina}%")

  changeHunger: (amt) ->
    @stats.hunger = @statsLimit(amt)
    # change hunger bar
    $('#hungerBar').css('width', "#{@stats.hunger}%")

  changeThirst: (amt) ->
    @stats.thirst = @statsLimit(amt)
    # change thirst bar
    $('#thirstBar').css('width', "#{@stats.thirst}%")

  increaseHealth: (delta) ->
    @changeHealth(@stats.health + delta)

  increaseStamina: (delta) ->
    @changeStamina(@stats.stamina + delta)

  increaseHunger: (delta) ->
    @changeHunger(@stats.hunger + delta)

  increaseThirst: (delta) ->
    @changeThirst(@stats.thirst + delta)

  decreaseHealth: (delta) ->
    @changeHealth(@stats.health - delta)

  decreaseStamina: (delta) ->
    @changeStamina(@stats.stamina - delta)

  decreaseHunger: (delta) ->
    @changeHunger(@stats.hunger - delta)

  decreaseThirst: (delta) ->
    @changeThirst(@stats.thirst - delta)

  statchange: (tile) ->
    @decreaseHealth(tile.health_cost)
    @decreaseStamina(tile.stamina_cost)
    @decreaseHunger(tile.hunger_cost)
    @decreaseThirst(tile.thirst_cost)

  decrement: ->
    if @alive
      if(map.getTileElement(@tilex, @tiley) == 2)
        @decreaseHealth(10)
      @increaseStamina(5)
      @decreaseThirst(5)
      @decreaseHunger(5)
      @decreaseHealth(5) if(@stats.hunger == 0)
      @decreaseHealth(5) if(@stats.thirst == 0)


  removeitem: (itemNo) ->
    @inventory.splice @inventory.indexOf(itemNo), 1
    $("#inventorySlots li").eq(@inventory.indexOf(itemNo)).remove()

  removeitemIndex: (itemindex) ->
    @inventory.splice itemindex, 1
    $("#inventorySlots li").eq(itemindex).remove()

  additem: (itemNo) ->
    if(@inventory.length < 6)
      @inventory.push itemNo
      $("#inventorySlots").append("<li style=\"background-image:url('#{map.getItemFromNumber(itemNo).tileImage.src}');\"></li>")
      return true
    else
      Game.announce "Inventory is full"
      return false

  setDead: ->
    Game.announce 'Your Player Died'
    @playerMovingInDir = [false, false, false, false] 
    @alive = false
    deathData = {id:@id, roomNumber:@roomNumber, tilex:@tilex, tiley:@tiley, inventory:@inventory}
    NetworkClient.sendDeathData(deathData)

  sendAttack: ->
    if @stats.stamina >= 5
      @decreaseStamina(5)
      attackData = {
        id: @id, 
        roomNumber: @roomNumber, 
        tilex: @tilex + @directionDeltas[@direction].x, 
        tiley: @tiley + @directionDeltas[@direction].y,
        damage: 3
      }
      NetworkClient.sendAttackData(attackData)

  attack: (damage) -> #method called when attack received
    if @alive
      Game.announce "You were attacked!!!"
      @decreaseHealth(damage)

  turn: (dir) ->
    @playerImage = @playerImages[dir]
    @direction = dir

  setMovingInDir: (dir) ->
    @playerMovingInDir = [false, false, false, false]
    @playerMovingInDir[dir] = true
  
  setNotMovingInAnyDir: ->
    @playerMovingInDir = [false, false, false, false]

  onKeyDown: (evt) =>
    #set corresponding moving direction boolean to true
    #set all others to false
    if @alive
      if (evt.keyCode == KEYCODE.leftarrow) # push left
        @setMovingInDir(@directions.left)
        @turn(@directions.left)
      if (evt.keyCode == KEYCODE.uparrow) # push up
        @setMovingInDir(@directions.up)
        @turn(@directions.up)
      if (evt.keyCode == KEYCODE.rightarrow) # push right
        @setMovingInDir(@directions.right)
        @turn(@directions.right)
      if (evt.keyCode == KEYCODE.downarrow) # push down
        @setMovingInDir(@directions.down)
        @turn(@directions.down)

  onKeyUp: (evt) =>
    if @alive
      @playerMovingInDir[@directions.left] = false if (evt.keyCode == KEYCODE.leftarrow)  # left arrow key up -> playerMovingLeft becomes false
      @playerMovingInDir[@directions.up] = false if (evt.keyCode == KEYCODE.uparrow)    # up arrow key up -> playerMovingUp becomes false
      @playerMovingInDir[@directions.right] = false if (evt.keyCode == KEYCODE.rightarrow) # right arrow key up -> playerMovingRight becomes false
      @playerMovingInDir[@directions.down] = false if (evt.keyCode == KEYCODE.downarrow)  # down arrow key up -> playerMovingDown becomes false

  update: =>
    @updatePlayerMovement()
    @updatePlayerTiles()

  updatePlayerMovement: =>
    # work out the adjacent squares to the player
    right = Math.floor((@posx+25)/25)
    left = Math.floor((@posx-1)/25)
    up = Math.floor((@posy-1)/25)
    down = Math.floor((@posy+25)/25)

    # if player is moving left or right, update it's stored horizontal position
    # if player not moving left or right, center it's horizontal position
    if (@playerMovingInDir[@directions.left] && map.inBounds(left, @tiley) && @stats.stamina > 0 && map.getTile(left,@tiley).walkable)
      @posx = @posx - @speed  
    else if (@playerMovingInDir[@directions.right] && map.inBounds(right, @tiley) && @stats.stamina > 0 && map.getTile(right,@tiley).walkable)
      @posx = @posx + @speed
    else
      @posx = @tilex*Settings.tileWidth

    # if player is moving up or down, update it's stored vertical position
    # if player not moving up or down, center it's vertical position
    if (@playerMovingInDir[@directions.up] && map.inBounds(@tilex,up) && @stats.stamina > 0 && map.getTile(@tilex,up).walkable)
      @posy = @posy - @speed
    else if (@playerMovingInDir[@directions.down] && map.inBounds(@tilex,down) && @stats.stamina > 0 && map.getTile(@tilex,down).walkable)
      @posy = @posy + @speed
    else
      @posy = @tiley*Settings.tileHeight

  updatePlayerTiles: =>
    # calculate the player's tile location from his pixel location
    @oldTilex = @tilex
    @oldTiley = @tiley
    @tilex = Math.floor((@posx+12.5) / 25);
    @tiley = Math.floor((@posy+12.5) / 25);
    # see if the tile has changed location
    if(@oldTilex != @tilex || @oldTiley != @tiley)
      # on player change square event
      @statchange(map.getTile(@tilex,@tiley))
      NetworkClient.sendPlayerData()

###
My Player tile
###

maxHealth = 30
maxStamina = 20
maxThirst = 100
maxHunger = 100

class Player
  constructor: (id, roomNumber, tilex, tiley, image, inventory, health, stamina, hunger, thirst, speed) -> 
    baseSource = if image? then image else "#{Settings.spriteDir}/sprite"
    @playerImages = [new Image(), new Image(), new Image(), new Image()]
    for x in [0..3]
      @playerImages[x].src = baseSource + x + ".png"
      @playerImages[x].isReady = false
      @playerImages[x].index = x
      @playerImages[x].onload = ->
        @isReady = true
    @turnDown()
    @inventory = if inventory? then inventory else []
    @health = if health? then health else maxHealth
    maxHealth = @health
    @stamina = if stamina? then stamina else maxStamina
    maxStamina = @stamina
    @hunger = if hunger? then hunger else maxHunger
    maxHunger = @hunger
    @thirst = if thirst? then thirst else maxThirst
    maxThirst = @thirst
    @speed = if speed? then speed else 0.8
    @posx = if posx? then posx else 0
    @posy = if posy? then posy else 0
    @id = if id? then id else -1
    @roomNumber = if roomNumber? then roomNumber else -1
    @tilex = Math.floor((@posx+12.5) / 25)
    @tiley = Math.floor((@posy+12.5) / 25)
    @oldTilex = @tilex
    @oldTilex = @tiley
    @playerMovingLeft = false
    @playerMovingUp = false
    @playerMovingRight = false
    @playerMovingDown = false
    @alive = true
  turnLeft: ->
    @playerImage = @playerImages[3]
    @direction = 3
  turnRight: ->
    @playerImage = @playerImages[1]
    @direction = 1
  turnDown: ->
    @playerImage = @playerImages[2]
    @direction = 2
  turnUp: ->
    @playerImage = @playerImages[0]
    @direction = 0
  #imgReady: -> @playerImages[0].isReady && @playerImages[1].isReady && @playerImages[2].isReady && @playerImages[3].isReady
  imgReady: -> @playerImage.isReady
  statchange: (tile) ->
    @health = @health - tile.health_cost
    @stamina = @stamina - tile.stamina_cost
    @hunger = @hunger - tile.hunger_cost
    @thirst = @thirst - tile.thirst_cost
  decrement: ->
    if @alive
      if(map.getTileElement(@tilex, @tiley) == 1)
        @health -= 2 if @health > 1
        @thirst -= 2 if @thirst > 1
      @stamina += 1 if @stamina < maxStamina
      @thirst -= 1 if @thirst > 0
      @hunger -= 1 if @hunger > 0
      @health -=1 if @thirst == 0
      @health -= 1 if @hunger == 0
      @setDead() if @health <= 0
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
      true
    else
      Game.announce "Inventory is full"
      false
  setDead: ->
    Game.announce 'Player Died'
    Game.player.playerMovingLeft = false
    Game.player.playerMovingUp = false
    Game.player.playerMovingRight = false
    Game.player.playerMovingDown = false
    @alive = false
  sendAttack: ->
    if @stamina >= 5
      @stamina -= 5
      NetworkClient.sendAttackData(3)
  attack: (damage) -> #method called when attack received
    if @alive
      Game.announce "You were attacked!!!"
      @health -= damage
      if (@health <= 0)
        @setDead()

  onKeyDown: (evt) =>
    #set corresponding moving direction boolean to true
    #set all others to false
    if @alive
      if (evt.keyCode == KEYCODE.leftarrow) # push left
        @playerMovingLeft = true
        @playerMovingUp = false
        @playerMovingRight = false
        @playerMovingDown = false
        @turnLeft()
      if (evt.keyCode == KEYCODE.uparrow) # push up
        @playerMovingUp = true
        @playerMovingLeft = false
        @playerMovingRight = false
        @playerMovingDown = false
        @turnUp()
      if (evt.keyCode == KEYCODE.rightarrow) # push right
        @playerMovingRight = true
        @playerMovingLeft = false
        @playerMovingUp = false
        @playerMovingDown = false
        @turnRight()
      if (evt.keyCode == KEYCODE.downarrow) # push down
        @playerMovingDown = true
        @playerMovingLeft = false
        @playerMovingUp = false
        @playerMovingRight = false
        @turnDown()

  onKeyUp: (evt) =>
    if @alive
      @playerMovingLeft = false if (evt.keyCode == KEYCODE.leftarrow)  # left arrow key up -> playerMovingLeft becomes false
      @playerMovingUp = false if (evt.keyCode == KEYCODE.uparrow)    # up arrow key up -> playerMovingUp becomes false
      @playerMovingRight = false if (evt.keyCode == KEYCODE.rightarrow) # right arrow key up -> playerMovingRight becomes false
      @playerMovingDown = false if (evt.keyCode == KEYCODE.downarrow)  # down arrow key up -> playerMovingDown becomes false

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
    if (@playerMovingLeft && map.inBounds(left, @tiley) && @stamina > 0 && map.getTile(left,@tiley).walkable)
      @posx = @posx - @speed  
    else if (@playerMovingRight && map.inBounds(right, @tiley) && @stamina > 0 && map.getTile(right,@tiley).walkable)
      @posx = @posx + @speed
    else
      @posx = @tilex*Settings.tileWidth
  
    # if player is moving up or down, update it's stored vertical position
    # if player not moving up or down, center it's vertical position
    if (@playerMovingUp && map.inBounds(@tilex,up) && @stamina > 0 && map.getTile(@tilex,up).walkable)
      @posy = @posy - @speed
    else if (@playerMovingDown && map.inBounds(@tilex,down) && @stamina > 0 && map.getTile(@tilex,down).walkable)
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
  

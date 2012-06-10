###
My Player tile
###

maxHealth = 30
maxStamina = 20
maxThirst = 100
maxHunger = 100

class Player
  constructor: (id, roomNumber, tilex, tiley, image, inventory, health, stamina, hunger, thirst, speed) -> 
    @playerImage = new Image()
    @playerImage.onload = => @imgReady = true
    @playerImage.src = if image? then image else "#{Settings.spriteDir}/sprite.png"
    @inventory = if inventory? then inventory else []
    @health = if health? then health else maxHealth
    maxHealth = @health
    @stamina = if stamina? then stamina else 20
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
    @alive = true;
  imgReady: false
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
    $(".item#{itemNo}").first().remove()
  setDead: ->
    Game.announce 'Player Died'
    @alive = false

  onKeyDown: (evt) =>
    #set corresponding moving direction boolean to true
    #set all others to false
    if @alive
      if (evt.keyCode == 37) # push left
        @playerMovingLeft = true
        @playerMovingUp = false
        @playerMovingRight = false
        @playerMovingDown = false
      if (evt.keyCode == 38) # push up
        @playerMovingUp = true
        @playerMovingLeft = false
        @playerMovingRight = false
        @playerMovingDown = false
      if (evt.keyCode == 39) # push right
        @playerMovingRight = true
        @playerMovingLeft = false
        @playerMovingUp = false
        @playerMovingDown = false
      if (evt.keyCode == 40) # push down
        @playerMovingDown = true
        @playerMovingLeft = false
        @playerMovingUp = false
        @playerMovingRight = false

  onKeyUp: (evt) =>
    if @alive
      @playerMovingLeft = false if (evt.keyCode == 37)  # left arrow key up -> playerMovingLeft becomes false
      @playerMovingUp = false if (evt.keyCode == 38)    # up arrow key up -> playerMovingUp becomes false
      @playerMovingRight = false if (evt.keyCode == 39) # right arrow key up -> playerMovingRight becomes false
      @playerMovingDown = false if (evt.keyCode == 40)  # down arrow key up -> playerMovingDown becomes false

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
  

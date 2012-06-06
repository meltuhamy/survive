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
    @playerImage.src = if image? then image else "#{window.spriteDir}/sprite.png"
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
  imgReady: false
  statchange: (tile) -> 
    @health = @health - tile.health_cost
    @stamina = @stamina - tile.stamina_cost
    @hunger = @hunger - tile.hunger_cost
    @thirst = @thirst - tile.thirst_cost
  decrement: ->
    @stamina += 1 if @stamina < maxStamina
    @thirst -= 1
    @hunger -= 1
  removeitem: (itemNo) ->
    @inventory.splice @inventory.indexOf(itemNo), 1
    $(".item#{itemNo}").first().remove()

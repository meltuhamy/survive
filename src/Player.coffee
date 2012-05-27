###
My Player tile
###

class Player
  constructor: (image, inventory, health, stamina, hunger, thirst, speed, playerx, playery) -> 
    @playerImage = new Image()
    @playerImage.onload = => @imgReady = true
    @playerImage.src = if image? then image else "sprite.png"
    @inventory = if inventory? then inventory else []
    @health = if health? then health else 10
    @stamina = if stamina? then stamina else 15
    @hunger = if hunger? then hunber else 20
    @thirst = if thirst? then thirst else 20
    @speed = if speed? then speed else 0.8
    @playerx = if playerx? then playerx else 0
    @playery = if playery? then playery else 0
    @playerSquarex = Math.floor((@playerx+12.5) / 25);
    @playerSquarey = Math.floor((@playery+12.5) / 25);
  imgReady: false
  statchange: (tile) -> 
    @health = @health - tile.health_cost
    @stamina = @stamina - tile.stamina_cost
    @hunger = @hunger - tile.hunger_cost
    @thirst = @thirst - tile.thirst_cost

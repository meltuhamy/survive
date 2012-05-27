
###
Map tiles
###
class Tile
  constructor: (src) -> 
    @tileImage = new Image()
    @tileImage.onload = => @tileReady = true
    @tileImage.src = src
  tileReady: false
  stamina_cost: 1
  thirst_cost: 0
  hunger_cost: 0
  health_cost: 0
  walkable: true

class GrassTile extends Tile
  constructor: -> super('grass.png')
  actions: [new DigTrapAction()]

class DeepWaterTile extends Tile
  constructor: -> 
    super('water.png')
    @stamina_cost = Number.MAX_VALUE
    @walkable = false
  actions: [new DrinkWaterAction()]

class ShallowWaterTile extends Tile
  constructor: -> 
    super('shallowwater.png')
    @stamina_cost = 3
  actions: [new DrinkWaterAction()]

class FireTile extends Tile
  constructor: -> 
    super('fire.png')
    @health_cost = 2
    @thirst_cost = 2
  actions: [new DigTrapAction()]

class HillTile extends Tile
  constructor: -> 
    super('hill.png')
    @walkable = false
  actions: [new DigTrapAction()]
  walkable: false

tileArray = [new GrassTile(), new FireTile(), new HillTile(), new ShallowWaterTile(), new DeepWaterTile()]


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
    @playerSquarex = Math.floor ((@playerx+12.5) / 25);
    @playerSquarey = Math.floor ((@playery+12.5) / 25);
  imgReady: false
  statchange: (tiletype) -> 
    @health = @health - tileArray[tiletype].health_cost
    @stamina = @stamina - tileArray[tiletype].stamina_cost
    @hunger = @hunger - tileArray[tiletype].hunger_cost
    @thirst = @thirst - tileArray[tiletype].thirst_cost
###
Item tiles
###
class Item
  constructor: (src) -> 
    @tileImage = new Image()
    @tileReady = false
    @tileImage.onload = => @tileReady = true
    @tileImage.src = src


class GreenHelm extends Item
  constructor: -> super('items/greenhelm.gif')
  actions: [new PickUpItemAction()]
  name: 'Green helmet'

class WaterBottle extends Item
  constructor: -> super('items/waterbottle.gif')
  actions: [new PickUpItemAction()]
  name: 'Water bottle'

itemarray = [0, new GreenHelm(), new WaterBottle()]

###
###

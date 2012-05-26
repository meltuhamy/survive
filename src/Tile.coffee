
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
  constructor: -> 
    @playerImage = new Image()
    @playerImage.onload = => @imgReady = true
    @playerImage.src = "sprite.png"
    @inventory = []
    @health = 10
    @stamina = 15
    @hunger = 20
    @thirst = 20
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

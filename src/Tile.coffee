
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
  thirst_cost: 1
  hunger_cost: 1
  health_cost: 0

class GrassTile extends Tile
  constructor: -> super('grass.png')
  actions: [new DigTrapAction()]

class DeepWaterTile extends Tile
  constructor: -> 
    super('water.png')
    @stamina_cost = Number.MAX_VALUE
  actions: [new DrinkWaterAction()]

class ShallowWaterTile extends Tile
  constructor: -> 
    super('shallowwater.png')
    @stamina_cost = 3
  actions: [new DrinkWaterAction()]

class FireTile extends Tile
  constructor: -> super('fire.png')
  actions: [new DigTrapAction()]

class HillTile extends Tile
  constructor: -> super('hill.png')
  actions: [new DigTrapAction()]

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
  imgReady: false

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

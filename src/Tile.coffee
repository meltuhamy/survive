
###
Map tiles
###
class Tile
  constructor: (src) -> 
    @tileImage = new Image()
    @tileImage.onload = => @tileReady = true
    @tileImage.src = src

class MapTile extends Tile
  tileReady: false
  stamina_cost: 1
  thirst_cost: 0
  hunger_cost: 0
  health_cost: 0
  walkable: true

class GrassTile extends MapTile
  constructor: -> super('grass.png')
  actions: [new DigTrapAction()]

class DeepWaterTile extends MapTile
  constructor: -> 
    super('water.png')
    @stamina_cost = Number.MAX_VALUE
    @walkable = false
  actions: [new DrinkWaterAction()]

class ShallowWaterTile extends MapTile
  constructor: -> 
    super('shallowwater.png')
    @stamina_cost = 3
  actions: [new DrinkWaterAction()]

class FireTile extends MapTile
  constructor: -> 
    super('fire.png')
    @health_cost = 2
    @thirst_cost = 2
  actions: [new DigTrapAction()]

class HillTile extends MapTile
  constructor: -> 
    super('hill.png')
    @walkable = false
  actions: [new DigTrapAction()]
  walkable: false

###
Item tiles
###

class GreenHelm extends Tile
  constructor: -> super('items/greenhelm.gif')
  actions: [new PickUpItemAction()]
  name: 'Green helmet'

class WaterBottle extends Tile
  constructor: -> super('items/waterbottle.gif')
  actions: [new PickUpItemAction()]
  name: 'Water bottle'



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
  actions: [new DigTrapAction(), new BuildBoobyTrapAction()]

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
  actions: [new DrinkWaterAction(), new PoisonWaterAction()]

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
  actions: []
  walkable: false

class TreeTile extends MapTile
  constructor: -> 
    super('tree.png')
    @walkable = false
  actions: [new ChopTreeAction(), new BurnTreeAction()]
  walkable: false

class HoleTrapTile extends MapTile
  constructor: -> 
    super('grass.png')
    @stamina_cost = 10
  actions: []

class BoobyTrapTile extends MapTile
  constructor: -> 
    super('grass.png')
    @health_cost = 4
  actions: []

class PoisonWaterTile extends MapTile
  constructor: -> 
    super('shallowwater.png')
    @health_cost = 2
  actions: [new DrinkPoisonedWaterAction(), new PoisonWaterAction()]

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

class Shovel extends Tile
  constructor: -> super('items/shovel.png')
  actions: [new PickUpItemAction()]
  name: 'Shovel'

class Log extends Tile
  constructor: -> super('items/log.png')
  actions: [new PickUpItemAction()]
  name: 'Log'

class Axe extends Tile
  constructor: -> super('items/axe.png')
  actions: [new PickUpItemAction()]
  name: 'Axe'

class Torch extends Tile
  constructor: -> super('items/torch.png')
  actions: [new PickUpItemAction()]
  name: 'Torch'

class Poison extends Tile
  constructor: -> super('items/poison.png')
  actions: [new PickUpItemAction()]
  name: 'Poison'

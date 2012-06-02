
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
  constructor: -> super("#{window.terrainDir}/grass.png")
  actions: [new DigTrapAction(), new BuildBoobyTrapAction()]

class DeepWaterTile extends MapTile
  constructor: -> 
    super("#{window.terrainDir}/water.png")
    @stamina_cost = Number.MAX_VALUE
    @walkable = false
  actions: [new DrinkWaterAction()]

class ShallowWaterTile extends MapTile
  constructor: -> 
    super("#{window.terrainDir}/shallowwater.png")
    @stamina_cost = 3
  actions: [new DrinkWaterAction(), new PoisonWaterAction()]

class FireTile extends MapTile
  constructor: -> 
    super("#{window.terrainDir}/fire.png")
    @health_cost = 2
    @thirst_cost = 2
  actions: [new DigTrapAction()]

class HillTile extends MapTile
  constructor: -> 
    super("#{window.terrainDir}/hill.png")
    @walkable = false
  actions: []
  walkable: false

class TreeTile extends MapTile
  constructor: -> 
    super("#{window.terrainDir}/tree.png")
    @walkable = false
  actions: [new ChopTreeAction(), new BurnTreeAction()]
  walkable: false

class HoleTrapTile extends MapTile
  constructor: -> 
    super("#{window.terrainDir}/grass.png")
    @stamina_cost = 10
  actions: []

class BoobyTrapTile extends MapTile
  constructor: -> 
    super("#{window.terrainDir}/grass.png")
    @health_cost = 4
  actions: []

class PoisonWaterTile extends MapTile
  constructor: -> 
    super("#{window.terrainDir}/shallowwater.png")
    @health_cost = 2
  actions: [new DrinkPoisonedWaterAction(), new PoisonWaterAction()]

###
Item tiles
###

class GreenHelm extends Tile
  constructor: -> super("#{window.itemDir}/greenhelm.gif")
  actions: [new PickUpItemAction()]
  name: 'Green helmet'

class WaterBottle extends Tile
  constructor: -> super("#{window.itemDir}/waterbottle.gif")
  actions: [new PickUpItemAction()]
  name: 'Water bottle'

class Shovel extends Tile
  constructor: -> super("#{window.itemDir}/shovel.png")
  actions: [new PickUpItemAction()]
  name: 'Shovel'

class Log extends Tile
  constructor: -> super("#{window.itemDir}/log.png")
  actions: [new PickUpItemAction()]
  name: 'Log'

class Axe extends Tile
  constructor: -> super("#{window.itemDir}/axe.png")
  actions: [new PickUpItemAction()]
  name: 'Axe'

class Torch extends Tile
  constructor: -> super("#{window.itemDir}/torch.png")
  actions: [new PickUpItemAction()]
  name: 'Torch'

class Poison extends Tile
  constructor: -> super("#{window.itemDir}/poison.png")
  actions: [new PickUpItemAction()]
  name: 'Poison'

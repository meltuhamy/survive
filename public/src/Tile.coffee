
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
  constructor: -> super("#{Settings.terrainDir}/grass.png")
  actions: [new DigTrapAction(), new BuildBoobyTrapAction()]

class DeepWaterTile extends MapTile
  constructor: -> 
    super("#{Settings.terrainDir}/water.png")
    @walkable = false
  actions: [new DrinkWaterAction(), new PoisonDeepWaterAction()]

class ShallowWaterTile extends MapTile
  constructor: -> 
    super("#{Settings.terrainDir}/shallowwater.png")
    @stamina_cost = 3
  actions: [new DrinkWaterAction(), new PoisonWaterAction()]

class FireTile extends MapTile
  constructor: -> 
    super("#{Settings.terrainDir}/fire.png")
    @health_cost = 2
    @thirst_cost = 2
  actions: []

class HillTile extends MapTile
  constructor: -> 
    super("#{Settings.terrainDir}/hill.png")
    @walkable = false
  actions: []

class TreeTile extends MapTile
  constructor: -> 
    super("#{Settings.terrainDir}/tree.png")
    @walkable = false
  actions: [new ChopTreeAction(), new BurnTreeAction()]

class HoleTrapTile extends MapTile
  constructor: -> 
    super("#{Settings.terrainDir}/grass.png")
    @stamina_cost = 10
  actions: []

class BoobyTrapTile extends MapTile
  constructor: -> 
    super("#{Settings.terrainDir}/grass.png")
    @health_cost = 4
  actions: []

class PoisonWaterTile extends MapTile
  constructor: -> 
    super("#{Settings.terrainDir}/shallowwater.png")
    @stamina_cost = 3
  actions: [ new DrinkPoisonedWaterAction(),new PoisonWaterAction()]

class PoisonDeepWaterTile extends MapTile
  constructor: -> 
    super("#{Settings.terrainDir}/water.png")
    @walkable = false
  actions: [new DrinkPoisonedWaterAction(), new PoisonDeepWaterAction()]

###
Item tiles
###

class itemTile extends Tile
  constructor: (src, @name) -> super(src)
  actions: [new PickUpItemAction()]
  inventoryActions: [new DropItemAction()]

class GreenHelm extends itemTile
  constructor: -> super("#{Settings.itemDir}/greenhelm.gif", 'Green helmet')

class Shovel extends itemTile
  constructor: -> super("#{Settings.itemDir}/shovel.png",'Shovel')

class Log extends itemTile
  constructor: -> super("#{Settings.itemDir}/log.png",'Log')

class Axe extends itemTile
  constructor: -> super("#{Settings.itemDir}/axe.gif",'Axe')

class Torch extends itemTile
  constructor: -> super("#{Settings.itemDir}/torch.png",'Torch')

class Poison extends itemTile
  constructor: -> super("#{Settings.itemDir}/poison.png",'Poison')

class Chicken extends itemTile
  constructor: ->
    super("#{Settings.itemDir}/chicken.png",'Chicken')
    @inventoryActions = @inventoryActions.concat(new EatItemAction(15,20,20))

class Berries extends itemTile
  constructor: ->
    super("#{Settings.itemDir}/berries.png",'Berries')
    @inventoryActions = @inventoryActions.concat(new EatItemAction(10,10,10))

class PoisonBerries extends itemTile
  constructor: ->
    super("#{Settings.itemDir}/poisonberries.png",'Poison Berries')
    @inventoryActions = @inventoryActions.concat(new EatItemAction(-10,0,5))

class WaterBottle extends itemTile
  constructor: ->
    super("#{Settings.itemDir}/waterbottle.gif",'Water bottle')
    @inventoryActions = @inventoryActions.concat(new DrinkBottleAction(5,5,20))

class PoisonWaterBottle extends itemTile
  constructor: ->
    super("#{Settings.itemDir}/waterbottle.gif",'Water bottle')
    @inventoryActions = @inventoryActions.concat(new DrinkBottleAction(-2,0,10))


class EmptyBottle  extends itemTile
  constructor: ->
    super("#{Settings.itemDir}/emptybottle.png",'Empty bottle')
    @inventoryActions = @inventoryActions.concat(new FillBottleAction())


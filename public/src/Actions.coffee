
###
ACTIONS
###
class Action
  constructor: (@actionname, @doFn) ->
  type: 'til'

class DigTrapAction extends Action
  constructor: -> 
    super('Dig Trap', (x,y) -> 
      hasShovel = false
      for invItem in [0...Game.player.inventory.length]
        if (Game.player.inventory[invItem] == map.ItemType.shovel)
          hasShovel = true
          break
      if (hasShovel) 
        map.setTileElement(x,y,map.TileType.holeTrap)
        Game.announce("Digging a trap at #{x},#{y}")
      else 
        Game.announce("Can't dig a trap at #{x},#{y}. I need a shovel.")
    )

class BuildBoobyTrapAction extends Action
  constructor: -> 
    super('Build Booby Trap', (x,y) -> 
      hasLog = false
      for invItem in [0...Game.player.inventory.length]
        if (Game.player.inventory[invItem] == map.ItemType.log)
          hasLog = true
          Game.player.removeitem(map.ItemType.log)
          break
      if (hasLog) 
        map.setTileElement(x,y,map.TileType.boobyTrap)
        Game.announce("Building a booby-trap at #{x},#{y}")
      else 
        Game.announce("Can't build a booby-trap at #{x},#{y}. I need a log.")
    )

class DrinkWaterAction extends Action
  constructor: -> 
    super('Drink water', (x,y) ->
      Game.player.increaseThirst(10)
      Game.announce("Drinking water at #{x},#{y}")
    )

class DrinkPoisonedWaterAction extends Action
  constructor: -> 
    super('Drink water', (x,y) -> 
      Game.player.increaseThirst(10)
      Game.player.decreaseHealth(5)
      Game.announce("Drinking poisoned water at #{x},#{y}")
    )

class ChopTreeAction extends Action
  constructor: -> 
    super('Chop Tree', (x,y) -> 
      hasAxe = false
      for i in [0...Game.player.inventory.length]
        if (Game.player.inventory[i] == map.ItemType.axe)
          hasAxe = true
          break
      if (hasAxe)
        map.setTileElement(x,y,map.TileType.grass)
        map.setItemElement(x,y,map.ItemType.log)
        Game.announce("Chopped down tree at #{x},#{y}.")
      else 
        Game.announce("Can't chop down tree at #{x},#{y}. I need an axe.")
    )

class BurnTreeAction extends Action
  constructor: -> 
    super('Burn Tree', (x,y) -> 
      hasTorch = false
      for i in [0...Game.player.inventory.length]
        if (Game.player.inventory[i] == map.ItemType.torch)
          hasTorch = true
          break
      if (hasTorch)
        map.setTileElement(x,y,map.TileType.fire)
        Game.announce("Burnt down tree at #{x},#{y}.")
      else 
        Game.announce("Can't burn down tree at #{x},#{y}. I need a torch.")
    )

#Could you rethink this logic
class PoisonWaterAction extends Action
  constructor: -> 
    super('Poison Water', (x,y) -> 
      hasPoison = false
      for i in [0...Game.player.inventory.length]
        if (Game.player.inventory[i] == map.ItemType.poison)
          hasPoison = true
          #Game.player.removeitem(7)
          Game.player.removeitemIndex(i)
          console.log "removed Item"
          Game.player.additem(map.ItemType.emptyBottle)
          console.log "added Item"
          break
      if (hasPoison)
        map.setTileElement(x,y,map.TileType.poisonWater)
        Game.announce("Poisoned water at #{x},#{y}.")
      else 
        Game.announce("Can't poison water at #{x},#{y}. I need a poison.")
    )

class PoisonDeepWaterAction extends Action
  constructor: -> 
    super('Poison Water', (x,y) -> 
      hasPoison = false
      for i in [0...Game.player.inventory.length]
        if (Game.player.inventory[i] == map.ItemType.poison)
          hasPoison = true
          #Game.player.removeitem(7)
          Game.player.removeitemIndex(i)
          Game.player.additem(map.ItemType.emptyBottle)
          break
      if (hasPoison)
        map.setTileElement(x,y,map.TileType.poisonDeepWater)
        Game.announce("Poisoned water at #{x},#{y}.")
      else 
        Game.announce("Can't poison water at #{x},#{y}. I need a poison.")
    )

class PickUpItemAction extends Action
  constructor: -> 
    super('Pick Up Item', (x,y) -> 
      pickedItem = map.getItemElement(x,y)
      if Game.player.additem pickedItem then map.removeItem(x,y)
    )

class DropItemAction extends Action
  constructor: ->
    super('Drop Item', (slotIndex) -> 
      if (map.getItemElement(Game.player.tilex,Game.player.tiley) == map.ItemType.none)
        map.setItemElement(Game.player.tilex,Game.player.tiley,Game.player.inventory[slotIndex])
        Game.player.removeitemIndex(slotIndex)
      else
        Game.announce("Can't drop item at #{Game.player.tilex},#{Game.player.tiley}. There is already another one there.")
    )

class EatItemAction extends Action
  constructor: (@healthgain, @staminagain, @hungergain) ->
    super('Eat Item', (slotIndex)->
      #announce that we're eting item
      #Game.announce "Eating " + Game.player.inventory
      Game.player.increaseHealth(@healthgain)
      Game.player.increaseStamina(@staminagain)
      Game.player.increaseHunger(@hungergain)
      Game.player.removeitemIndex(slotIndex)
    )

class DrinkBottleAction extends Action
  constructor: (@healthgain, @staminagain, @thirstgain) ->
    super('Drink Water', (slotIndex)->
      #announce that we're drinkin water
      Game.player.increaseHealth(@healthgain)
      Game.player.increaseStamina(@staminagain)
      Game.player.increaseThirst(@thirstgain)
      Game.player.removeitemIndex(slotIndex)
      Game.player.additem(map.ItemType.emptyBottle)
    )

class FillBottleAction extends Action
  constructor: ->
    super('Fill Bottle', (slotIndex)->
      nextTile = map.getTileElement(Game.player.tilex + Game.player.directionDeltas[Game.player.direction].x ,  Game.player.tiley + Game.player.directionDeltas[Game.player.direction].y)
      if (nextTile == map.TileType.shallowWater || nextTile == map.TileType.deepWater)
        Game.player.removeitemIndex(slotIndex)
        Game.player.additem(map.ItemType.waterBottle)
      else
        Game.announce "You need open water to fill an empty bottle"
    )

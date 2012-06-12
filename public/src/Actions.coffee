
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
        if (Game.player.inventory[invItem] == ItemType.shovel)
          hasShovel = true
          break
      if (hasShovel) 
        map.setTileElement(x,y,TileType.holeTrap)
        Game.announce("Digging a trap at #{x},#{y}")
      else 
        Game.announce("Can't dig a trap at #{x},#{y}. I need a shovel.")
    )

class BuildBoobyTrapAction extends Action
  constructor: -> 
    super('Build Booby Trap', (x,y) -> 
      hasLog = false
      for invItem in [0...Game.player.inventory.length]
        if (Game.player.inventory[invItem] == ItemType.log)
          hasLog = true
          Game.player.removeitem(ItemType.log)
          break
      if (hasLog) 
        map.setTileElement(x,y,TileType.boobyTrap)
        Game.announce("Building a booby-trap at #{x},#{y}")
      else 
        Game.announce("Can't build a booby-trap at #{x},#{y}. I need a log.")
    )

class DrinkWaterAction extends Action
  constructor: -> 
    super('Drink water', (x,y) ->
      Game.player.thirst = 90
      Game.player.health += 5
      if Game.player.health > maxHealth then Game.player.health = maxHealth 
      Game.announce("Drinking water at #{x},#{y}")
    )

class DrinkPoisonedWaterAction extends Action
  constructor: -> 
    super('Drink water', (x,y) -> 
      Game.player.thirst += 10 if Game.player.thirst < 90
      Game.player.health = Game.player.health - 2
      Game.announce("Drinking poisoned water at #{x},#{y}")
    )

class ChopTreeAction extends Action
  constructor: -> 
    super('Chop Tree', (x,y) -> 
      hasAxe = false
      for i in [0...Game.player.inventory.length]
        if (Game.player.inventory[i] == ItemType.axe)
          hasAxe = true
          break
      if (hasAxe)
        console.log "has axe"
        map.setTileElement(x,y,TileType.grass)
        map.setItemElement(x,y,TileType.log)
        Game.announce("Chopped down tree at #{x},#{y}.")
      else 
        Game.announce("Can't chop down tree at #{x},#{y}. I need an axe.")
    )

class BurnTreeAction extends Action
  constructor: -> 
    super('Burn Tree', (x,y) -> 
      hasTorch = false
      for i in [0...Game.player.inventory.length]
        if (Game.player.inventory[i] == ItemType.torch)
          hasTorch = true
          break
      if (hasTorch)
        map.setTileElement(x,y,TileType.fire)
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
        if (Game.player.inventory[i] == TileType.poison)
          hasPoison = true
          #Game.player.removeitem(7)
          Game.player.removeitemIndex(i)
          console.log "removed Item"
          Game.player.additem(11)
          console.log "added Item"
          break
      if (hasPoison)
        map.setTileElement(x,y,8)
        Game.announce("Poisoned water at #{x},#{y}.")
      else 
        Game.announce("Can't poison water at #{x},#{y}. I need a poison.")
    )

class PoisonDeepWaterAction extends Action
  constructor: -> 
    super('Poison Water', (x,y) -> 
      hasPoison = false
      for i in [0...Game.player.inventory.length]
        if (Game.player.inventory[i] == 7)
          hasPoison = true
          #Game.player.removeitem(7)
          Game.player.removeitemIndex(i)
          console.log "removed Item"
          Game.player.additem(11)
          console.log "added Item"
          break
      if (hasPoison)
        map.setTileElement(x,y,9)
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
      if (map.getItemElement(Game.player.tilex,Game.player.tiley) == 0)
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
      Game.player.health += @healthgain
      if Game.player.health > maxHealth then Game.player.health = maxHealth
      Game.player.stamina += @staminagain
      if Game.player.stamina > maxStamina then Game.player.stamina = maxStamina
      Game.player.hunger += @hungergain
      if Game.player.hunger > maxHunger then Game.player.hunger = maxHunger
      Game.player.removeitemIndex(slotIndex)
    )

class DrinkBottleAction extends Action
  constructor: (@healthgain, @staminagain, @thirstgain) ->
    super('Drink Water', (slotIndex)->
      #announce that we're drinkin water
      Game.player.health += @healthgain
      if Game.player.health > maxHealth then Game.player.health = maxHealth
      Game.player.stamina += @staminagain
      if Game.player.stamina > maxStamina then Game.player.stamina = maxStamina
      Game.player.thirst += @thirstgain
      if Game.player.thirst > maxThirst then Game.player.thirst = maxThirst
      Game.player.removeitemIndex(slotIndex)
      Game.player.additem(11)
    )

class FillBottleAction extends Action
  constructor: ->
    super('Fill Bottle', (slotIndex)->
      nextTile = map.getTileElement(Game.player.tilex + directions[Game.player.direction].x ,  Game.player.tiley + directions[Game.player.direction].y)
      if (nextTile == 3)
        Game.player.removeitemIndex(slotIndex)
        Game.player.additem(2)
      else
        Game.announce "You need open water to fill an empty bottle"
    )

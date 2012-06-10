
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
        if (Game.player.inventory[invItem] == 3)
          hasShovel = true
          break
      if (hasShovel) 
        map.setTileElement(x,y,6)
        Game.announce("Digging a trap at #{x},#{y}")
      else 
        Game.announce("Can't dig a trap at #{x},#{y}. I need a shovel.")
    )

class BuildBoobyTrapAction extends Action
  constructor: -> 
    super('Build Booby Trap', (x,y) -> 
      hasLog = false
      for invItem in [0...Game.player.inventory.length]
        if (Game.player.inventory[invItem] == 4)
          hasLog = true
          Game.player.removeitem(4)
          break
      if (hasLog) 
        map.setTileElement(x,y,7)
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
        if (Game.player.inventory[i] == 5)
          hasAxe = true
          break
      if (hasAxe)
        console.log "has axe"
        map.setTileElement(x,y,0)
        map.setItemElement(x,y,4)
        Game.announce("Chopped down tree at #{x},#{y}.")
      else 
        Game.announce("Can't chop down tree at #{x},#{y}. I need an axe.")
    )

class BurnTreeAction extends Action
  constructor: -> 
    super('Burn Tree', (x,y) -> 
      hasTorch = false
      for i in [0...Game.player.inventory.length]
        if (Game.player.inventory[i] == 6)
          hasTorch = true
          break
      if (hasTorch)
        map.setTileElement(x,y,1)
        Game.announce("Burnt down tree at #{x},#{y}.")
      else 
        Game.announce("Can't burn down tree at #{x},#{y}. I need a torch.")
    )

class PoisonWaterAction extends Action
  constructor: -> 
    super('Poison Water', (x,y) -> 
      hasPoison = false
      for i in [0...Game.player.inventory.length]
        if (Game.player.inventory[i] == 7)
          hasPoison = true
          Game.player.removeitem(7)
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
          Game.player.removeitem(7)
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
      map.setItemElement(Game.player.tilex,Game.player.tiley,Game.player.inventory[slotIndex])
      Game.player.removeitemIndex(slotIndex)
    )

class EatItemAction extends Action
  constructor: (@healthgain, @staminagain, @hungergain) ->
    super('Eat Item', (slotIndex)->
      Game.player.health += @healthgain
      if Game.player.health > maxHealth then Game.player.health = maxHealth 
      Game.player.stamina += @staminagain
      if Game.player.stamina > maxStamina then Game.player.stamina = maxStamina 
      Game.player.hunger += @hungergain
      if Game.player.hunger > maxHunger then Game.player.hunger = maxHunger 
    )
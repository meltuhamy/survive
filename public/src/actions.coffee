
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
      for invItem in [0...player.inventory.length]
        if (player.inventory[invItem] == 3)
          hasShovel = true
          break
      if (hasShovel) 
        map.setTileElement(x,y,6)
        alert("Digging a trap at #{x},#{y}")
      else 
        alert("Can't dig a trap at #{x},#{y}. I need a shovel.")
    )

class BuildBoobyTrapAction extends Action
  constructor: -> 
    super('Build Booby Trap', (x,y) -> 
      hasLog = false
      for invItem in [0...player.inventory.length]
        if (player.inventory[invItem] == 4)
          hasLog = true
          player.removeitem(4)
          break
      if (hasLog) 
        map.setTileElement(x,y,7)
        alert("Building a booby-trap at #{x},#{y}")
      else 
        alert("Can't build a booby-trap at #{x},#{y}. I need a log.")
    )

class DrinkWaterAction extends Action
  constructor: -> 
    super('Drink water', (x,y) -> 
    	player.thirst = 100
    	alert("Drinking water at #{x},#{y}")
    )

class DrinkPoisonedWaterAction extends Action
  constructor: -> 
    super('Drink water', (x,y) -> 
      player.thirst += 10 if player.thirst < 90
      player.health = player.health - 2
      alert("Drinking poisoned water at #{x},#{y}")
    )

class ChopTreeAction extends Action
  constructor: -> 
    super('Chop Tree', (x,y) -> 
      hasAxe = false
      for i in [0...player.inventory.length]
        if (player.inventory[i] == 5)
          hasAxe = true
          break
      if (hasAxe)
        console.log "has axe"
        map.setTileElement(x,y,0)
        map.setItemElement(x,y,4)
        alert("Chopped down tree at #{x},#{y}.")
      else 
        alert("Can't chop down tree at #{x},#{y}. I need an axe.")
    )

class BurnTreeAction extends Action
  constructor: -> 
    super('Burn Tree', (x,y) -> 
      hasTorch = false
      for i in [0...player.inventory.length]
        if (player.inventory[i] == 6)
          hasTorch = true
          break
      if (hasTorch)
        map.setTileElement(x,y,1)
        alert("Burnt down tree at #{x},#{y}.")
      else 
        alert("Can't burn down tree at #{x},#{y}. I need a torch.")
    )

class PoisonWaterAction extends Action
  constructor: -> 
    super('Poison Water', (x,y) -> 
      hasPoison = false
      for i in [0...player.inventory.length]
        if (player.inventory[i] == 7)
          hasPoison = true
          player.removeitem(7)
          break
      if (hasPoison)
        map.setTileElement(x,y,8)
        alert("Poisoned water at #{x},#{y}.")
      else 
        alert("Can't poison water at #{x},#{y}. I need a poison.")
    )

class PoisonDeepWaterAction extends Action
  constructor: -> 
    super('Poison Water', (x,y) -> 
      hasPoison = false
      for i in [0...player.inventory.length]
        if (player.inventory[i] == 7)
          hasPoison = true
          player.removeitem(7)
          break
      if (hasPoison)
        map.setTileElement(x,y,9)
        alert("Poisoned water at #{x},#{y}.")
      else 
        alert("Can't poison water at #{x},#{y}. I need a poison.")
    )

class PickUpItemAction extends Action
  constructor: -> 
    super('Pick Up Item', (x,y) -> 
      pickedItem = map.getItemElement(x,y)
      pushInventory(pickedItem)
      player.inventory.push(pickedItem)
      map.removeItem(x,y)
    )

class EatItemAction extends Action
  constructor: (@healthgain, @staminagain, @hungergain) ->
    super('Eat Item', ->
      player.health += @healthgain
      player.health = maxHealth if @player.health > maxHealth
      player.stamina += @staminagain
      player.stamina = maxStamina if @player.stamina > maxStamina
      player.hunger += @hungergain
      player.hunger = maxHunger if @player.hunger > maxHunger
    )

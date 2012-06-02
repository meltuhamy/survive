
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
          player.inventory.splice invItem, 1
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
    	player.thirst = 20
    	alert("Drinking water at #{x},#{y}")
    )

class DrinkPoisonedWaterAction extends Action
  constructor: -> 
    super('Drink water', (x,y) -> 
      player.thirst = 20
      player.health = player.health - 2
      alert("Drinking water at #{x},#{y}")
    )

class ChopTreeAction extends Action
  constructor: -> 
    super('Chop Tree', (x,y) -> 
      hasAxe = false
      console.log player.inventory
      for i in [0...player.inventory.length]
        console.log player.inventory[i]
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
      for y in [0...player.inventory.length]
        if (player.inventory[y] == 6)
          hasTorch = true
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
      for y in [0...player.inventory.length]
        if (player.inventory[y] == 7)
          hasPoison = true
      if (hasPoison)
        map.setTileElement(x,y,8)
        alert("Poisoned water at #{x},#{y}.")
      else 
        alert("Can't poison water at #{x},#{y}. I need a poison.")
    )


class PickUpItemAction extends Action
  constructor: -> 
    super('Pick Up Item Action', (x,y) -> 
    	pickedItem = map.getItemElement(x,y)
    	player.inventory.push(pickedItem)
    	map.removeItem(x,y)
    	#alert("I picked up the damned item at #{x}, #{y}. It is a #{pickedItem.name}")
    )

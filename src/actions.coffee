
###
ACTIONS
###
class Action
  constructor: (@actionname, @doFn) ->

class DigTrapAction extends Action
  constructor: -> super('Dig Trap', (x,y) -> 
    hasShovel = false
    for y in [0...player.inventory.length-1]
      if (player.inventory[y] == 3)
        hasShovel = true
    if (hasShovel) 
      setTile(x,y,6)
      alert("Digging a trap at #{x},#{y}")
    else 
      alert("Can't dig a trap at #{x},#{y}. I need a shovel."))

class BuildBoobyTrapAction extends Action
  constructor: -> super('Build Booby Trap', (x,y) -> 
    hasLog = false
    for y in [0...player.inventory.length-1]
      if (player.inventory[y] == 4)
        hasLog = true
    if (hasLog) 
      setTile(x,y,7)
      alert("Building a booby-trap at #{x},#{y}")
    else 
      alert("Can't build a booby-trap at #{x},#{y}. I need a log."))

class DrinkWaterAction extends Action
  constructor: -> super('Drink water', (x,y) -> 
  	player.thirst = 20
  	alert("Drinking water at #{x},#{y}"))

class DrinkPoisonedWaterAction extends Action
  constructor: -> super('Drink water', (x,y) -> 
    player.thirst = 20
    player.health = player.health - 2
    alert("Drinking water at #{x},#{y}"))

class ChopTreeAction extends Action
  constructor: -> super('Chop Tree', (x,y) -> 
    hasAxe = false
    for y in [0...player.inventory.length-1]
      if (player.inventory[y] == 5)
        hasAxe = true
    if (hasAxe)
      map.setTile(x,y,0)
      map setItem(x,y,3)
      alert("Chopped down tree at #{x},#{y}.")
    else 
      alert("Can't chop down tree at #{x},#{y}. I need an axe."))

class BurnTreeAction extends Action
  constructor: -> super('Burn Tree', (x,y) -> 
    hasTorch = false
    for y in [0...player.inventory.length-1]
      if (player.inventory[y] == 6)
        hasTorch = true
    if (hasTorch)
      map.setTile(x,y,1)
      alert("Burnt down tree at #{x},#{y}.")
    else 
      alert("Can't burn down tree at #{x},#{y}. I need a torch."))

class PoisonWaterAction extends Action
  constructor: -> super('Poison Water', (x,y) -> 
    hasPoison = false
    for y in [0...player.inventory.length-1]
      if (player.inventory[y] == 7)
        hasPoison = true
    if (hasPoison)
      map.setTile(x,y,8)
      alert("Poisoned water at #{x},#{y}.")
    else 
      alert("Can't poison water at #{x},#{y}. I need a poison."))


class PickUpItemAction extends Action
  constructor: -> super('Pick Up Item Action', (x,y) -> 
  	pickedItem = map.getItem(x,y)
  	player.inventory.push(pickedItem.name)
  	map.removeItem(x,y)
  	alert("I picked up the damned item at #{x}, #{y}. It is a #{pickedItem.name}"))
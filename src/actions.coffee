
###
ACTIONS
###
class Action
  constructor: (@actionname, @doFn) ->

class DigTrapAction extends Action
  constructor: -> super('Dig Trap', (x,y) -> alert("Digging a trap at #{x},#{y}"))

class DrinkWaterAction extends Action
  constructor: -> super('Drink water', (x,y) -> alert("Drinking water at #{x},#{y}"))

class PickUpItemAction extends Action
  constructor: -> super('Pick Up Item Action', (x,y) -> 
  	pickedItem = map.getItem(x,y)
  	player.inventory.push(pickedItem.name)
  	map.removeItem(x,y)
  	alert("I picked up the damned item at #{x}, #{y}. It is a #{pickedItem.name}"))

extends Resource
class_name ItemManagement

var itemDropped = preload("res://Items/DroppedItem.tscn")


func create_item(ID:String, withForce:bool=false):
	var newItem = itemDropped.instance()
	newItem.item = ID
	if withForce:
		var force = (Vector2.UP+Vector2(rand_range(-.25, .25), 0)).normalized()*70
		newItem.apply_central_impulse(force)
	return newItem

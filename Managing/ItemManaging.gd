extends Resource
class_name ItemManagement

var itemDropped = preload("res://Items/DroppedItem.tscn")


func create_item(ID:String):
	var newItem = itemDropped.instance()
	newItem.item = ID
	return newItem

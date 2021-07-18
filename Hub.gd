extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	# Testing
	for i in 10:
		var map = preload("res://UI/Inventory/ItemMap.tres")
		var keys = map.items.keys()
		keys.shuffle()
		var item = GameManager.itemManager.create_item(keys.pop_front())
		item.position = Vector2(95+(i*32), 375)
		add_child(item)

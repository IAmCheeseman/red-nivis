extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	GameManager.gravity = GameManager.DEFAULT_GRAVITY
	var itemMap = ItemMap.new()
	var keys = itemMap.items.keys()
	keys.shuffle()
	var itemManager = ItemManagement.new()
	for i in 10:
		var newItem = itemManager.create_item(keys.pop_front())
		newItem.position = Vector2((i*32)+32, 350)
		add_child(newItem)

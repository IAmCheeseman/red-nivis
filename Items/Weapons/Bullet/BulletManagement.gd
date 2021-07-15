extends Node2D

func _ready():
	GameManager.spawnManager = self
	# Testing
	var item = GameManager.itemManager.create_item("Cheese")
	item.position = position
	add_child(item)


func add_bullet(bullet:Node2D):
	add_child(bullet)


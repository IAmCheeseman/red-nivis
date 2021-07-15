extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	# Testing
	var item = GameManager.itemManager.create_item("Laser_Shotgun")
	item.position = Vector2(95, 375)
	add_child(item)

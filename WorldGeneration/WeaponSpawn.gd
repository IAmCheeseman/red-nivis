extends Node2D

func _ready():
	if rand_range(0, 2) > 1:
		queue_free()
		return
	var newGun = load("res://Items/Weapons/Gun.tscn").instance()
	add_child(newGun)

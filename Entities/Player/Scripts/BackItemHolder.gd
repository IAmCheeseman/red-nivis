extends Node2D

func _process(_delta):
	if get_child_count() > 0:
		get_child(0).pivot.rotation_degrees = -90
		get_child(0).scale.y = 1

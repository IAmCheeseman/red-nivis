extends Node2D


func enable_shooters() -> void:
	for i in get_children():
		i.start()

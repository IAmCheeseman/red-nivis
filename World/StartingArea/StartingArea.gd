extends Node2D


func _on_lab_loading_zone_loadArea() -> void:
	$ScreenTransition.out()
	var timer = Timer.new()
	timer.connect("timeout", get_tree(), "change_scene", ["res://World/World.tscn"])
	add_child(timer)
	timer.start(.3)

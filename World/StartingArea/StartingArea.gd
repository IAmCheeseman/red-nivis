extends Node2D

var audioLayout:AudioBusLayout = preload("res://default_bus_layout.tres")


func _ready():
	AudioServer.set_bus_effect_enabled(4, 0, false)

func _on_lab_loading_zone_loadArea() -> void:
	$ScreenTransition.out()
	var timer = Timer.new()
	timer.connect("timeout", get_tree(), "change_scene", ["res://World/World0.tscn"])
	add_child(timer)
	timer.start(.3)

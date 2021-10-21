extends Node2D

var audioLayout:AudioBusLayout = preload("res://default_bus_layout.tres")

var worldData = preload("res://World/WorldManagement/WorldData.tres")


func _ready():
	AudioServer.set_bus_effect_enabled(4, 0, false)

func _on_lab_loading_zone_loadArea() -> void:
	$ScreenTransition.out()
	var timer = Timer.new()
	

	timer.connect("timeout", self, "load_world")
	add_child(timer)
	timer.start(.3)


func load_world():
	randomize()
	worldData.generate_world()
	var _discard = get_tree().change_scene("res://World/WorldManagement/World.tscn")

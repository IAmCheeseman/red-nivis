extends Node2D

const STARTING_AREA = "res://World/StartingArea/StartingArea.tscn"
const WORLD = "res://World/WorldManagement/World.tscn"


func _ready():
	randomize()
	
	if OS.has_feature("standalone"):
		OS.set_window_always_on_top(false)
	OS.window_fullscreen = Settings.fullscreen
	var target = STARTING_AREA if GameManager.load_run() != OK else WORLD
	var _discard = get_tree().change_scene(target)

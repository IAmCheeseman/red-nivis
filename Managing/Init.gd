extends Node2D

const STARTING_AREA = "res://World/StartingArea/StartingArea.tscn"
const WORLD = "res://World/WorldManagement/World.tscn"


func _ready():
	randomize()
	OS.set_window_title("Red Nivis")
	
	OS.window_fullscreen = Settings.fullscreen
	var target = STARTING_AREA if GameManager.load_run() != OK else WORLD
	var _discard = get_tree().change_scene(target)

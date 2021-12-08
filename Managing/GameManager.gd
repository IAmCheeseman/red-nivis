extends Node2D


var isDead = false
var editingInventory = false
var inGUI = false
var currentCamera:Camera2D

var revealMap := false

var usingController := false

var attackingEnemies = 0 setget set_attacking_enemies

var spawnManager:Node2D
var itemManager:ItemManagement = ItemManagement.new()
var frameFreezer:FrameFreezer = FrameFreezer.new()

var player: Node2D

var worldData = preload("res://World/WorldManagement/WorldData.tres")

# warning-ignore:unused_signal
signal screenshake
signal zoom_in(zoom,time,zoomPos)

func _input(_event):
	if Input.is_action_just_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	if Input.is_key_pressed(KEY_R):
		var _discard = get_tree().reload_current_scene()


func set_attacking_enemies(value:int):
	attackingEnemies = value
	attackingEnemies = clamp(attackingEnemies, 0, 1)



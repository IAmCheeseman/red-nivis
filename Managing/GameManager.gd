extends Node2D


var isDead = false
var editingInventory = false
var currentCamera:Camera2D

var attackingEnemies = 0 setget set_attacking_enemies

var spawnManager:Node2D
var itemManager:ItemManagement = ItemManagement.new()
var frameFreezer:FrameFreezer = FrameFreezer.new()

# warning-ignore:unused_signal
signal screenshake


func _input(_event):
	if Input.is_action_just_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen


func set_attacking_enemies(value:int):
	attackingEnemies = value
	attackingEnemies = clamp(attackingEnemies, 0, 1)



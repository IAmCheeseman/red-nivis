extends Node2D

const DEFAULT_GRAVITY = 350
const HEART_CHANCE = .07
const SKY = "Sky"
const SURFACE = "Surface"
const UNDERGROUND = "Underground"
const CAVERNS = "Caverns"

var planet = 0
var worldLayers:Dictionary
var worldSize:Vector2
var isDead = false
var currentCamera:Camera2D
var editingInventory = false

var attackingEnemies = 0 setget set_attacking_enemies

var spawnManager:Node2D
var itemManager:ItemManagement = ItemManagement.new()
var frameFreezer:FrameFreezer = FrameFreezer.new()

var gravity = 350

# warning-ignore:unused_signal
signal screenshake


func _input(_event):
	if Input.is_action_just_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen


func get_world_layer(y:float):
	return {
		"Sky" : y >= worldLayers[SKY] and y < worldLayers[SURFACE],
		"Surface" : y >= worldLayers[SURFACE] and y < worldLayers[UNDERGROUND],
		"Underground": y >= worldLayers[UNDERGROUND] and y < worldLayers[CAVERNS],
		"Caverns" : y >= worldLayers[CAVERNS]
	}


func set_attacking_enemies(value:int):
	attackingEnemies = value
	attackingEnemies = clamp(attackingEnemies, 0, 1)



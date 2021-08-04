extends Node2D

const DEFAULT_GRAVITY = 350
const SKY = "Sky"
const SURFACE = "Surface"
const UNDERGROUND = "Underground"
const CAVERNS = "Caverns"

var planet = 0
var worldLayers:Dictionary
var worldSize:Vector2
var isDead = false
var heldItems = [null, null]

var attackingEnemies = 0 setget set_attacking_enemies

var spawnManager:Node2D
var itemManager = ItemManagement.new()

var gravity = 350

# warning-ignore:unused_signal
signal screenshake


func _input(_event):
	if Input.is_action_just_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen


#func load_scene(loadPath):
#	yield(get_tree(), "idle_frame")
## warning-ignore:return_value_discarded
#	get_tree().change_scene(loadPath)


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


func percentage_of(a:float, b:float) -> float:
	if a == 0 or b == 0:
		return 0.0
	return (a/b)*100


func percentage_from(percent:float, a:float) -> float:
	if percent == 0 or a == 0:
		return 0.0
	var tinyPercent = 100/percent
	return a/tinyPercent


func is_even(number): return !(number % 2)



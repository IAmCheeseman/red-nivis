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
# warning-ignore:unused_signal
signal zoom_in(zoom,time,zoomPos)


var controlMaterial = CanvasItemMaterial.new()

func _ready() -> void:
	controlMaterial.light_mode = CanvasItemMaterial.LIGHT_MODE_UNSHADED
	var _discard = get_tree().connect("node_added", self, "_on_node_added")


func _input(_event):
	if Input.is_action_just_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	if Input.is_key_pressed(KEY_R):
		var _discard = get_tree().reload_current_scene()


func _on_node_added(node: Node) -> void:
	if node is Light2D and !Settings.lightingEffects:
		node.queue_free()
	if node is Control and !node.material:
		node.material = controlMaterial


func set_attacking_enemies(value:int):
	attackingEnemies = value
	attackingEnemies = clamp(attackingEnemies, 0, 1)



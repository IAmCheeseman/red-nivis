extends Node2D


var isDead = false
var editingInventory = false
var inGUI = false
var currentCamera:Camera2D

var attackingEnemies = 0 setget set_attacking_enemies

var spawnManager:Node2D
var itemManager:ItemManagement = ItemManagement.new()
var frameFreezer:FrameFreezer = FrameFreezer.new()

# warning-ignore:unused_signal
signal screenshake


func _ready() -> void:
	var _discard = get_tree().connect("node_added", self, "_on_node_added")


func _input(_event):
	if Input.is_action_just_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	if Input.is_key_pressed(KEY_R):
		var _discard = get_tree().reload_current_scene()


func _on_node_added(node: Node) -> void:
	if !(node.has_method("_process") or node.has_method("_physics_process")):
		node.set_process(false)


func set_attacking_enemies(value:int):
	attackingEnemies = value
	attackingEnemies = clamp(attackingEnemies, 0, 1)



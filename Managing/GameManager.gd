extends Node2D


var isDead = false
var editingInventory = false
var inGUI = false
var currentCamera:Camera2D

var revealMap := false

var usingController := false

var spawnManager:Node2D
var itemManager:ItemManagement = ItemManagement.new()
var frameFreezer:FrameFreezer = FrameFreezer.new()

var currentlyAttackingEnemies := []

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


func _on_node_added(node: Node) -> void:
	if node is Light2D and !Settings.lightingEffects:
		node.queue_free()
	if node is Control and !node.material:
		node.material = controlMaterial


func attacks_capped() -> bool:
	return currentlyAttackingEnemies.size() > 2


func add_attacking_enemy(enemy: Node) -> void:
	if attacks_capped(): return
	currentlyAttackingEnemies.append(enemy)
	enemy.connect("tree_exiting", self, "remove_attacking_enemy", [enemy])


func enemy_is_attacking(enemy: Node) -> bool:
	return currentlyAttackingEnemies.has(enemy)


func remove_attacking_enemy(enemy: Node) -> void:
	currentlyAttackingEnemies.erase(enemy)

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
	if node is Light2D and false:
		node.queue_free()
	if node is Control and !node.material:
		node.material = controlMaterial


func attacks_capped() -> bool:
	return currentlyAttackingEnemies.size() > 2


func add_attacking_enemy(enemy: Node) -> void:
	if attacks_capped(): return
	currentlyAttackingEnemies.append(enemy)
	if self in enemy.get_signal_connection_list("tree_exiting"):
		var _discard = enemy.connect("tree_exiting", self, "remove_attacking_enemy", [enemy])


func enemy_is_attacking(enemy: Node) -> bool:
	return currentlyAttackingEnemies.has(enemy)


func remove_attacking_enemy(enemy: Node) -> void:
	currentlyAttackingEnemies.erase(enemy)


func save_run() -> void:
	var playerData = preload("res://Entities/Player/Player.tres")
	var inventory = preload("res://UI/Inventory/Inventory.tres")
	
	var runData = {
		"playerData:maxHealth"      : playerData.maxHealth,
		"playerData:health"         : playerData.health,
		"playerData:maxStamina"     : playerData.maxStamina,
		"playerData:money"          : playerData.money,
		"playerData:upgrades"       : playerData.upgrades,
		"inventory:items"           : inventory.items,
		"worldData:rooms"           : worldData.rooms,
		"worldData:position"        : worldData.savePosition,
		"worldData:savePosition"    : worldData.savePosition,
		"worldData:playerPos"       : worldData.savePlayerPos,
		"worldData:savePlayerPos"   : worldData.savePlayerPos,
		"worldData:moveDir"         : worldData.moveDir
	}
	
	var dm := DataManager.new()
	var ok = dm.save_data(runData, Globals.RUN_FILE_NAME)


func load_run() -> int:
	var playerData = preload("res://Entities/Player/Player.tres")
	var inventory = preload("res://UI/Inventory/Inventory.tres")
	
	var dm := DataManager.new()
	var runData = dm.load_data(Globals.RUN_FILE_NAME)
	
	if runData.size() == 0: return ERR_DOES_NOT_EXIST
	
	for i in runData.keys():
		var splitKey = i.split(":")
		var obj = splitKey[0]
		var val = splitKey[1]
		
		match obj:
			"playerData": obj = playerData
			"inventory": obj = inventory
			"worldData": obj = worldData
			_: return ERR_INVALID_DATA
		
		obj.set(val, runData[i])
		if runData[i] is Array: runData[i] = "[Array]"
		print(splitKey[0] + "." + str(val) + " = " + str(runData[i]))
	worldData.moveDir = Vector2.DOWN
	return OK


func clear_run() -> void:
	var dm := DataManager.new()
	dm.clear_data(Globals.RUN_FILE_NAME)

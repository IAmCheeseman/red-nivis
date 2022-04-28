extends Node2D


var isDead = false
var editingInventory = false
var inGUI = false
var currentCamera:Camera2D

var revealMap := false

var usingController := false

var pickedUpItems := []

var spawnManager:Node2D
var itemManager:ItemManagement = ItemManagement.new()
var frameFreezer:FrameFreezer = FrameFreezer.new()

var currentlyAttackingEnemies := []

var underwater = false

var player: Node2D
var mainTileset: TileMap

var worldData = preload("res://World/WorldManagement/WorldData.tres")

# warning-ignore:unused_signal
signal screenshake
# warning-ignore:unused_signal
signal zoom_in(zoom,time,zoomPos)


var controlMaterial = CanvasItemMaterial.new()

var rpBiome = "None"
var rpGun = "No gun"


func _init():
	frameFreezer.gm = self


func update_rp(state:String=rpBiome, details:String=rpGun) -> void:
	if OS.get_name() == "OSX": return

	yield(get_tree(), "idle_frame")
	var activity = Discord.Activity.new()
	activity.set_type(Discord.ActivityType.Playing)
	activity.set_name("Red Nivis")
	activity.set_state("Exploring %s" % tr(state))
	activity.set_details("Using %s" % tr(details))

	var assets = activity.get_assets()
	assets.set_large_image("icon")
	assets.set_large_text("Red Nivis")

	var _result = yield(Discord.activity_manager.update_activity(activity), "result").result
#	if result != Discord.Result.Ok:
#		push_error(result)


func _ready() -> void:
	update_rp()
	load_game()
	controlMaterial.light_mode = CanvasItemMaterial.LIGHT_MODE_UNSHADED
	var _discard = get_tree().connect("node_added", self, "_on_node_added")


func _input(_event):
	if Input.is_action_just_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen


func _on_node_added(node: Node) -> void:
	if node is Light2D and Settings.gfx == Settings.GFX_BAD:
		node.hide()
	elif node is Control and !node.material:
		node.material = controlMaterial
	elif node is Button:
		node.focus_mode = Control.FOCUS_NONE


func attacks_capped(cap: int=2) -> bool:
	return currentlyAttackingEnemies.size() > cap


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
		"playerData:maxHealth"          : playerData.maxHealth,
		"playerData:health"             : playerData.health,
		"playerData:maxStamina"         : playerData.maxStamina,
		"playerData:money"              : playerData.money,
		"playerData:upgrades"           : playerData.upgrades,
		"inventory:items"               : inventory.items,
		"worldData:rooms"               : worldData.rooms,
		"worldData:position"            : worldData.savePosition,
		"worldData:savePosition"        : worldData.savePosition,
		"worldData:playerPos"           : worldData.savePlayerPos,
		"worldData:savePlayerPos"       : worldData.savePlayerPos,
		"worldData:moveDir"             : worldData.moveDir,
		"fastTravel:discoveredStations" : FastTravel.discoveredStations
	}

	var dm := DataManager.new()
	var _ok = dm.save_data(runData, Globals.RUN_FILE_NAME)


func load_run() -> int:
	var playerData = preload("res://Entities/Player/Player.tres")
	var inventory = preload("res://UI/Inventory/Inventory.tres")

	var dm := DataManager.new()
	var runData = dm.load_data(Globals.RUN_FILE_NAME)

	if runData.size() == 0: return ERR_DOES_NOT_EXIST

	print("------ Run -------")
	for i in runData.keys():
		var splitKey = i.split(":")
		var obj = splitKey[0]
		var val = splitKey[1]

		match obj:
			"playerData": obj = playerData
			"inventory" :  obj = inventory
			"worldData" :  obj = worldData
			"fastTravel": obj = FastTravel
			_: return ERR_INVALID_DATA

		obj.set(val, runData[i])
		if runData[i] is Array: runData[i] = "[Array]"
		print(splitKey[0] + "." + str(val) + " = " + str(runData[i]))
	worldData.moveDir = Vector2.DOWN

	for i in worldData.rooms:
		for r in i:
			if r.constantRoom:
				r.roomIcon = load(r.constantRoom).roomIcon
	print("------------------")
	return OK


func clear_run() -> void:
	var dm := DataManager.new()
	dm.clear_data(Globals.RUN_FILE_NAME)


func save_game() -> void:
	var dm := DataManager.new()
	var playerData = preload("res://Entities/Player/Player.tres")

	var saveData := {
		"highScore"            : playerData.highScore,
		"unlockedUpgrades"     : playerData.unlockedUpgrades,
		"deaths"               : playerData.deaths,
		"tutorialEnabled"      : playerData.tutorialEnabled,
	}

	var _ok = dm.save_data(saveData, Globals.GAME_FILE_NAME)


func load_game() -> void:
	var dm := DataManager.new()
	var playerData = preload("res://Entities/Player/Player.tres")

	var saveData := dm.load_data(Globals.GAME_FILE_NAME)

	for i in saveData.keys():
		playerData.set(i, saveData[i])

	if Steam.is_init():
		for i in playerData.unlockedAchievements:
			Achievement.unlock(i)


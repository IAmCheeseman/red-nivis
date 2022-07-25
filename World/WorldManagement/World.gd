extends Node2D

onready var player = $Props/Player
onready var props = $Props
#onready var atmosphere = $Atmosphere
#onready var mistSpawner = $Props/Player/MistSpawner
onready var solids = $Props/Tiles/LabSolids
onready var platforms = $Props/Tiles/OneWayPlatforms
onready var background = $Props/Tiles/LabBackground
onready var solidColorBG = $Background/BGColor
onready var canvasLayer =$CanvasLayer
onready var mainCamMove = $Props/CameraZones/CameraMoveZone
onready var screenTrans = $ScreenTransition
onready var tilesContainer = $Props/Tiles
onready var enemies = $Props/Enemies
onready var roomClearer = $RoomClearer
onready var darkness = $Darkness
onready var generator = $Generator

var worldData = preload("res://World/WorldManagement/WorldData.tres")

export var automaticBlockRemoval := true

var waves := 0
var lockedIn: bool
var viableEnemySpawns := []
var exitBlockers := []

signal added_enemies

func _ready() -> void:
	AudioServer.set_bus_effect_enabled(4, 0, true)
	AudioServer.set_bus_effect_enabled(5, 0, true)
	
	
	if !worldData.get_current_room().discovered:
		player.playerData.score += Globals.ROOM_POINTS
	generator.create_room()
	seed(worldData.position.x*worldData.position.y)
	lockedIn = rand_range(0, 1) < .2
	if worldData.get_current_room().cleared:
		for i in exitBlockers: i.queue_free()
		exitBlockers.clear()
	if worldData.playerPos != Vector2.ZERO:
		player.global_position = worldData.playerPos
		worldData.playerPos = Vector2.ZERO
	
	var biome = worldData.get_biome_by_index(worldData.get_current_room().biome)
	
	GameManager.mainTileset = solids
	GameManager.inGUI = false
	
	GameManager.rpBiome = biome.name
	GameManager.update_rp()
	
	var timer = Timer.new()
	timer.wait_time = 2.9
	timer.autostart = true
	timer.one_shot = true
	add_child(timer)
	background.modulate = Color.darkgray
	timer.connect("timeout", self, "_on_index_timer_timeout")

	if worldData.savePosition == Vector2.ZERO: worldData.savePosition = worldData.position
	GameManager.save_run()


func _process(delta: float) -> void:
	player.playerData.time += delta


func _on_index_timer_timeout() -> void:
	emit_signal("added_enemies", enemies)
	
	roomClearer.isChecking = true
	roomClearer.add_enemies()


func _on_drop_gun(gun, pos) -> void:
	gun.position = pos
	gun.isPickedUp = false
	gun.set_logic(false)
	GameManager.spawnManager.add_item(gun)


func _on_load_area(area: Area2D, direction: Vector2) -> void:
	if !area.is_in_group("player"):
		return
	if player.playerData.isDead:
		return
	GameManager.inGUI = false
	var timer = Timer.new()
	timer.wait_time = .4
	timer.connect("timeout", get_tree(), "reload_current_scene")
	add_child(timer)
	timer.start()

	var room = worldData.get_current_room()
	if enemies.get_child_count() == 0: room.cleared = true

	worldData.position += direction
	worldData.moveDir = direction

	screenTrans.out()


func _on_enemies_cleared(remove:bool=automaticBlockRemoval) -> void:
	if rand_range(0, 1) < .5 and waves < 1 and lockedIn:
		generator.spawn_enemies()
		waves += 1
		
		var timer = get_tree().create_timer(2.9)
		timer.connect("timeout", self, "_on_index_timer_timeout")
		return
	roomClearer.isChecking = false
	if remove:
		for eb in exitBlockers:
			if eb is Node2D:
				eb.queue_free()
		exitBlockers.clear()

	var currRoom = worldData.get_current_room()
	if currRoom.cleared or currRoom.constantRoom: return
	var clearEffectPos = roomClearer.lastKilledEnemyPos
	var newClearEffect = preload("res://World/VisualEffects/RoomClear.tscn").instance()
	newClearEffect.global_position = clearEffectPos
	GameManager.spawnManager.spawn_object(newClearEffect)
	GameManager.frameFreezer.freeze_frames(.2)


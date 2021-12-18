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
onready var generator = $Generator

var worldData = preload("res://World/WorldManagement/WorldData.tres")

var waves := 0
var lockedIn:bool
var viableEnemySpawns := []
var exitBlockers := []


func _ready() -> void:
	generator.create_room()
	seed(worldData.position.x*worldData.position.y)
	lockedIn = rand_range(0, 1) < .2
	if !lockedIn:
		for i in exitBlockers: i.queue_free()
		exitBlockers.clear()
	if worldData.playerPos != Vector2.ZERO:
		player.global_position = worldData.playerPos
		worldData.playerPos = Vector2.ZERO
	var timer = get_tree().create_timer(2.9)
	background.modulate = Color.darkgray
	timer.connect("timeout", self, "_on_index_timer_timeout")


func _on_index_timer_timeout() -> void:
	roomClearer.isChecking = true


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
	
	worldData.position += direction
	worldData.moveDir = direction

	screenTrans.out()


func _on_enemies_cleared() -> void:
	if rand_range(0, 1) < .5 and waves < 1 and lockedIn:
		generator.spawn_enemies()
		waves += 1
		roomClearer.isChecking = true
		return
	roomClearer.isChecking = false
	for eb in exitBlockers:
		if eb is Node2D:
			eb.queue_free()
	exitBlockers.clear()


extends Node2D

var audioLayout:AudioBusLayout = preload("res://BusLayout.tres")

var worldData = preload("res://World/WorldManagement/WorldData.tres")

onready var player = $Player
onready var movementLock = $Managing/MovementLock

var busVolume: float

func _ready():
	Engine.time_scale = 1
	GameManager.rpBiome = "Aboveground"
	GameManager.update_rp()
	set_process(false)
	busVolume = AudioServer.get_bus_volume_db(4)
	AudioServer.set_bus_volume_db(4, .01)
	AudioServer.set_bus_volume_db(5, .01)


func _process(delta: float) -> void:
	player.playerData.time += delta
	player.position.x = lerp(player.position.x, movementLock.position.x, 10 * delta)


func _on_lab_loading_zone_loadArea() -> void:
	$ScreenTransition.out()
	var timer = Timer.new()


	timer.connect("timeout", self, "load_world")
	add_child(timer)
	timer.start(.3)


func load_world():
	randomize()
	worldData.generate_world()
	AudioServer.set_bus_volume_db(4, busVolume)
	AudioServer.set_bus_volume_db(5, busVolume)
	var _discard = get_tree().change_scene("res://World/WorldManagement/World.tscn")


func _on_movement_lock_area_entered(_area: Area2D) -> void:
	player.lockMovement = true
	set_process(true)

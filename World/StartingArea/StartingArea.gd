extends Node2D

var audioLayout:AudioBusLayout = preload("res://default_bus_layout.tres")

var worldData = preload("res://World/WorldManagement/WorldData.tres")

onready var player = $Player
onready var movementLock = $Managing/MovementLock


func _ready():
	set_process(false)
	AudioServer.set_bus_effect_enabled(4, 0, false)


func _process(delta: float) -> void:
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
	var _discard = get_tree().change_scene("res://World/WorldManagement/World.tscn")


func _on_movement_lock_area_entered(_area: Area2D) -> void:
	player.lockMovement = true
	set_process(true)

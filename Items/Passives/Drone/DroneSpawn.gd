extends Node2D

const PLAYER = preload("res://Entities/Player/Player.tres")
const DRONE = preload("res://Items/Passives/Drone/Drone.tscn")


func _ready() -> void:
	yield(TempTimer.idle_frame(self), "timeout")
	
	var drone = DRONE.instance()
	GameManager.spawnManager.spawn_object(drone)

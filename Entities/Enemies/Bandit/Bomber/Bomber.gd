extends Node2D

const DRONE = preload("res://Entities/Enemies/Bandit/Bomber/Drone.tscn")

onready var spawnParticles = $SpawnParticles
onready var collisionChecker = $DroneChecker

var player: Node2D
var currentDrone: Node2D

func spawn_drone() -> void:
	if is_instance_valid(currentDrone): return
	
	var newDrone = DRONE.instance()
	
	var pos = global_position
	if collisionChecker.is_colliding():
		pos = collisionChecker.get_collision_point()
	
	newDrone.global_position = pos
	newDrone.bomber = self
	newDrone.player = player
	GameManager.spawnManager.spawn_object(newDrone)
	currentDrone = newDrone
	
	spawnParticles.emitting = true

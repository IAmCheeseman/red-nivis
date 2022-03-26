extends Node2D

const DRONE = preload("res://Entities/Enemies/Bandit/Bomber/Drone.tscn")

onready var spawnParticles = $SpawnParticles

var player: Node2D
var currentDrone: Node2D

func spawn_drone() -> void:
	if is_instance_valid(currentDrone): return
	
	var newDrone = DRONE.instance()
	newDrone.global_position = global_position
	newDrone.bomber = self
	newDrone.player = player
	GameManager.spawnManager.spawn_object(newDrone)
	currentDrone = newDrone
	
	spawnParticles.emitting = true

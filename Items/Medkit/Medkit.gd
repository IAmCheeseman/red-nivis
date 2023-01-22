extends RigidBody2D

onready var fd = $FloorDetector


var playerData = preload("res://Entities/Player/Player.tres")


func _process(_delta: float) -> void:
	if global_position.distance_to(
		playerData.playerObject.global_position
	) < 5 and fd.is_colliding():
		playerData.heal(20)
		queue_free()

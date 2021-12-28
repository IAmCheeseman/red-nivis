extends Node2D


func _ready() -> void:
	yield(TempTimer.idle_frame(self), "timeout")
	var player = preload("res://Entities/Player/Player.tres")
	if global_position.distance_to(player.playerObject.global_position) < 24:
		queue_free()
	$Hitbox/CollisionShape2D.disabled = false
	set_process(false)
	set_physics_process(false)

extends RigidBody2D

var player = preload("res://Player/Player.tres")

func _on_player_detection_area_entered(_area):
	player.health = clamp(player.health+25, 0, player.maxHealth)
	player.playerObject.update_healthbar()
	queue_free()

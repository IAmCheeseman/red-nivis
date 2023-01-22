extends RigidBody2D

var player = preload("res://Entities/Player/Player.tres")

func _on_player_detection_area_entered(area):
	if area.is_in_group("player"):
		player.health = clamp(player.health + 20, 0, player.maxHealth)
		player.playerObject.gameOverlay.update_health(Vector2.ZERO)
		queue_free()

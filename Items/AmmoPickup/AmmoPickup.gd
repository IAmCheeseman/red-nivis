extends RigidBody2D

var player = preload("res://Player/Player.tres")

func _on_player_detection_area_entered(_area):
	player.ammo = clamp(player.ammo+32, 0, player.maxAmmo)
	queue_free()

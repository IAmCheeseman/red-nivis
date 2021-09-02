extends RigidBody2D

var player = preload("res://Player/Player.tres")

func _on_player_detection_area_entered(_area):
	player.ammo = clamp(player.ammo+32, 0, player.maxAmmo)
	player.playerObject._on_ammo_changed()
	queue_free()

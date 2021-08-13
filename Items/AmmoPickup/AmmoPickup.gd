extends RigidBody2D

var player = preload("res://Player/Player.tres")

func _on_player_detection_area_entered(area):
	player.ammo += 32
	queue_free()

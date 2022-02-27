extends "res://Entities/Enemies/Bosses/Billy/Bomb.gd"



func explode() -> void:
	var newExplosion = explosion.instance()
	newExplosion.global_position = global_position
	GameManager.spawnManager.spawn_object(newExplosion)
	newExplosion.set_size(16)
	queue_free()

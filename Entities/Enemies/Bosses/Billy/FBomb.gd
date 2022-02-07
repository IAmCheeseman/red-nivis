extends "res://Entities/Enemies/Bosses/Billy/Bomb.gd"


func _ready() -> void:
	vel = global_position.direction_to(GameManager.player.global_position) * 300
	vel.y -= 200


func explode() -> void:
	var newExplosion = explosion.instance()
	newExplosion.global_position = global_position
	GameManager.spawnManager.spawn_object(newExplosion)
	queue_free()

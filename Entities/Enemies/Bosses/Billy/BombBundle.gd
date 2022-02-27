extends "res://Entities/Enemies/Bosses/Billy/Bomb.gd"

export var bombCount = 4

var bomb = preload("res://Entities/Enemies/Bosses/Billy/TinyGrenade.tscn")


func _ready() -> void:
	vel = global_position.direction_to(GameManager.player.global_position) * 300
	vel.y -= 200


func explode() -> void:
	var newExplosion = explosion.instance()
	newExplosion.global_position = global_position
	GameManager.spawnManager.spawn_object(newExplosion)
	newExplosion.set_size(28)
	for i in bombCount:
		var newBomb = bomb.instance()
		newBomb.global_position = global_position - Vector2(0, 12)
		newBomb.apply_central_impulse(Vector2(rand_range(-48, 48), -rand_range(160, 400)))
		newBomb.time = rand_range(1.0, 3.0)
		newBomb.size = 8
		GameManager.spawnManager.call_deferred("spawn_object", newBomb)
	queue_free()

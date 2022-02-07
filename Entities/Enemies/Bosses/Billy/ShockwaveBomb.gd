extends "res://Entities/Enemies/Bosses/Billy/Bomb.gd"


func _ready() -> void:
	vel.y -= 200


func explode() -> void:
	var spawnPoint = rc.get_collision_point()
	for i in 2:
		var newExplosion = preload("res://Entities/Enemies/Shockwave/Shockwave.tscn").instance()
		newExplosion.global_position = spawnPoint
		newExplosion.scale.x = -1 if i == 0 else 1
		newExplosion.speed = 150
		GameManager.spawnManager.add_child(newExplosion)
	queue_free()

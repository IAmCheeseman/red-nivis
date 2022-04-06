extends "res://Entities/Enemies/Goblins/Goblin.gd"


func attack_state(delta: float) -> void:
	var newExplosion = preload("res://Entities/Enemies/Explosion/Explosion.tscn").instance()
	newExplosion.global_position = global_position
	newExplosion.set_size(48)
	GameManager.spawnManager.add_child(newExplosion)
	
	queue_free()

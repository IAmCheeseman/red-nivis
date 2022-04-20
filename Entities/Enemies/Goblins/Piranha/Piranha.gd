extends "res://Entities/Enemies/Goblins/Goblin.gd"


var eyes = []


func attack_state(_delta: float) -> void:
	var newExplosion = preload("res://Entities/Enemies/Explosion/Explosion.tscn").instance()
	newExplosion.global_position = global_position
	newExplosion.set_size(48)
	GameManager.spawnManager.add_child(newExplosion)

	queue_free()


func flip() -> void:
	if eyes.size() == 0:
		for i in sprite.get_children():
			eyes.append(i.position)
	
	if !flipV:
		sprite.flip_h = vel.x > 0
		for i in sprite.get_children().size():
			sprite.get_child(i).position.x = eyes[i].x if !sprite.flip_h else -eyes[i].x
	else:
		sprite.flip_v = vel.x < 0

extends Node2D

var children = []


func _ready() -> void:
	for i in 10:
		var newChild = preload("res://Entities/Enemies/Goblins/Piranha/PiranhaChild.tscn").instance()
		newChild.global_position = global_position
		newChild.z_index = owner.z_index + 1
		GameManager.spawnManager.spawn_object(newChild)
		
		children.append(newChild)


func _process(delta: float) -> void:
	for i in children:
		if !is_instance_valid(i):
			children.erase(i)
			continue
		i.targetPos = global_position + Vector2(
			rand_range(-16, 16),
			rand_range(-16, 16)
		)

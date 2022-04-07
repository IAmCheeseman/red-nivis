extends Node2D

var children = []
var childrenKilled = 0
var totalChildren = 6

var target: Vector2

func _ready() -> void:
	for i in totalChildren:
		var newChild = preload("res://Entities/Enemies/Goblins/Piranha/PiranhaChild.tscn").instance()
		newChild.global_position = global_position + Vector2(
			rand_range(-32, 32),
			rand_range(-32, 32)
		)
		newChild.z_index = owner.z_index + 1
		GameManager.spawnManager.spawn_object(newChild)

		children.append(newChild)


func _process(_delta: float) -> void:
	for i in children.size():
		if i > children.size()-1: break
		var p = children[i]
		if !is_instance_valid(p):
			childrenKilled += 1
			children.erase(p)
			continue

		if i > childrenKilled:
			p.targetPos = global_position + Vector2(
				rand_range(-16, 16),
				rand_range(-16, 16)
			)
		else:
			p.state = p.states.ATTACK

		if children.size() == 0:
			owner.state = owner.states.ATTACK
	if children.size() == 0:
		owner.state = owner.states.ATTACK

extends Node2D

export var playerPath : NodePath
export var acceleration = 1
export var maxDist = 8

var speed = rand_range(5, 9)

onready var local_target = position

onready var shadow = $Shadow

func _process(delta):
	var player = get_node(playerPath)
	var target = player.global_position+local_target

	if global_position.distance_to(target) > maxDist:
		global_position = (target.direction_to(global_position)*maxDist)+target
	elif global_position.distance_to(target) <= 1:
		target = global_position

	global_position += global_position.direction_to(target)*speed*delta


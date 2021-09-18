extends Area2D

export var mustBeInSight:bool = true

onready var sight = $Sight

func get_player():
	var collisions = get_overlapping_areas()
	# Looping though the collisions and checking if
	# it is the player and if the enemy can see the
	# player, if it can it will return the player
	for c in collisions:
		sight.cast_to = c.global_position-global_position
		sight.force_raycast_update()
		if c.is_in_group("player"):
			if sight.is_colliding() and mustBeInSight:
				continue
			return c
	return null

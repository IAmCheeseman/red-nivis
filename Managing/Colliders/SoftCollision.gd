extends Area2D

func get_push_vector():
	var areas = get_overlapping_areas()
	for area in areas:
		if !area.is_in_group("SoftCollision"):
			continue
		return -global_position.direction_to(area.global_position)
	return Vector2.ZERO


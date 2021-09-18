extends Area2D

func get_push_vector():
	var areas = get_overlapping_areas()
	var pushVector = Vector2.ZERO
	for area in areas:
		if !area.is_in_group("SoftCollision"):
			continue
		pushVector += -global_position.direction_to(area.global_position)
	return pushVector.normalized()


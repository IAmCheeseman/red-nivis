extends StaticBody2D



func _explode(area: Area2D) -> void:
	if area.is_in_group("Explosion"):
		queue_free()

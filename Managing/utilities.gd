extends Reference
class_name Utils


static func percentage_of(a:float, b:float):
	if a == 0 or b == 0:
		return 0.0
	return (a/b)*100


static func percentage_from(percent:float, a:float):
	if percent == 0 or a == 0:
		return 0.0
	var tinyPercent = 100/percent
	return a/tinyPercent


static func is_even(number:int) -> bool: return !(number % 2)


static func coin_flip() -> bool: return is_even(randi())


static func free_children(node:Node): for i in node.get_children(): i.queue_free()


static func get_relative_to_camera(node:Node2D, camera:Camera2D) -> Vector2:
	var camSize = node.get_viewport_rect().end
	var camPos:Vector2 =\
	(camera.global_position + camera.offset) - (camSize / 2)
	return (node.global_position - camPos) * (OS.window_size / camSize)


static func get_global_mouse_position() -> Vector2:
	return\
		Cursor.find_node("Sprite").global_position\
		+ (GameManager.currentCamera.global_position - (GameManager.get_viewport_rect().end*.5))

static func get_local_mouse_position(node) -> Vector2:
	return node.to_local(get_global_mouse_position())


static func set_mouse_position(pos: Vector2) -> void:
	Cursor.find_node("Sprite").global_position = pos


static func round_dir_to_target(
node: Node2D, dir: Vector2,
correction_range: int=20, targetLayer: int=4) -> Vector2:

	var rc := RayCast2D.new()
	rc.enabled = true
	rc.collision_mask = targetLayer
	rc.collide_with_areas = true
	rc.collide_with_bodies = false
	node.add_child(rc)

	var collisions := []
	for i in correction_range:
		var angle = deg2rad((correction_range*.5)-i)
		rc.cast_to = dir.rotated(angle)*1000
		rc.force_raycast_update()
		if rc.is_colliding():
			var pos = rc.get_collider().global_position
			collisions.append(node.global_position.direction_to(pos))
	rc.queue_free()

	if collisions.size() == 0: return dir
	return collisions.front()


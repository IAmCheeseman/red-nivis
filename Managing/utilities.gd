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


static func is_even(number:int): return !(number % 2)


static func free_children(node:Node):
	for i in node.get_children():
		i.queue_free()


static func get_relative_to_camera(node:Node2D, camera:Camera2D) -> Vector2:
	var camPos:Vector2 = (camera.global_position+camera.offset)\
		-node.get_viewport_rect().end*.5
	var position:Vector2 = node.global_position-camPos
	
	return position


static func get_global_mouse_position() -> Vector2:
	return\
		Cursor.find_node("Sprite").global_position\
		+(GameManager.currentCamera.global_position - (GameManager.get_viewport_rect().end*.5))

static func get_local_mouse_position(node) -> Vector2:
	return node.to_local(get_global_mouse_position())


static func set_mouse_position(pos: Vector2) -> void:
	Cursor.find_node("Sprite").global_position = pos


static func dmg_to_hp(
	dmg: float, cooldown: float, fightTime: float):
	var dps = dmg/cooldown
	return (dps*fightTime)*.75



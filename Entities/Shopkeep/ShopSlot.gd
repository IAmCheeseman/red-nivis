extends ColorRect

var item:Dictionary

var inventory = preload("res://UI/Inventory/Inventory.tres")

func set_item(_item:Dictionary) -> void:
	item = _item
	var display = item.scene.duplicate()
	display.position = rect_size*.5
	add_child(display)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("use_item") and get_global_rect().has_point(get_global_mouse_position()):
		inventory.add_item(item)
		queue_free()

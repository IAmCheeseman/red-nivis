extends ColorRect

var item:Dictionary


func set_item(_item:Dictionary) -> void:
	item = _item
	var display = item.scene.duplicate()
	display.position = rect_size*.5
	add_child(display)

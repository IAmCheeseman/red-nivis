extends ColorRect

onready var costLabel = $Hbox/Cost

var item:Dictionary

var inventory = preload("res://UI/Inventory/Inventory.tres")
var player = preload("res://Entities/Player/Player.tres")


func set_item(_item:Dictionary) -> void:
	item = _item
	costLabel.text = str(item.cost)
	var display = item.scene.duplicate()
	display.position = rect_size*.5
	add_child(display)


func _input(event: InputEvent) -> void:
	var hasEnoughMoney = player.money-item.cost >= 0
	var mouseOver = get_global_rect().has_point(get_global_mouse_position())
	if event.is_action_pressed("use_item") and mouseOver and hasEnoughMoney:
		inventory.add_item(item)
		player.money -= item.cost
		queue_free()

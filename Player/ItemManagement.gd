extends Node

export var itemHolderPath:NodePath

onready var itemHolder = get_node(itemHolderPath)


func add_item(item:PackedScene):
	for i in itemHolder.get_children():
		i.queue_free()
	var newItem = item.instance()
	if newItem.has_meta("player"): newItem.player = get_parent()
	itemHolder.add_child(newItem)

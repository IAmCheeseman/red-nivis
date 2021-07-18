extends Node

export var itemHolderPath:NodePath

onready var itemHolder = get_node(itemHolderPath)

var inventory = preload("res://UI/Inventory/Inventory.tres")


func _ready():
	inventory.connect("selectedSlotChanged", self, "add_item")


func add_item():
	for i in itemHolder.get_children():
		i.queue_free()
	var id = inventory.items[inventory.selectedSlot]
	if id == null: return
	var item = inventory.get_item(id)
	if item.scene == null:
		var newItem = load("res://Items/Item.tscn").instance()
		itemHolder.add_child(newItem)
		newItem.sprite.texture = item.texture
		newItem.sprite.offset.x = item.texture.get_width()/2
		return

	var newItem = item.scene.instance()
	newItem.player = get_parent()
	itemHolder.add_child(newItem)

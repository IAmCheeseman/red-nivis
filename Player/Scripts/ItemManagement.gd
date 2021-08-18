extends Node

export var itemHolderPath:NodePath

onready var itemHolder = get_node(itemHolderPath)

var inventory = preload("res://UI/Inventory/Inventory.tres")


func _ready():
	inventory.connect("selectedSlotChanged", self, "add_item")
	inventory.connect("itemsChanged", self, "add_item")
	add_item()


func add_item():
	for i in itemHolder.get_children():
		i.queue_free()
	var id = inventory.items[inventory.selectedSlot]
	if id == null: return

	var item = inventory.get_item(id)
	if item == null and id.is_valid_integer():
		var newItem = load("res://Items/Weapons/Gun.tscn").instance()
		newItem._seed = int(id)
		itemHolder.add_child(newItem)
		return

	if item.scene == null:
		var newItem = load("res://Items/Item.tscn").instance()
		itemHolder.add_child(newItem)
		newItem.sprite.texture = item.texture
		newItem.sprite.offset.x = item.texture.get_width()/2
		return

	var newItem = item.scene.instance()
	newItem.player = get_parent()
	itemHolder.add_child(newItem)

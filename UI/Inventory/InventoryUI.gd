extends Control

onready var slots = $CenterContainer/Slots

var slot = preload("res://UI/Inventory/Slot.tscn")
var inventory = preload("res://UI/Inventory/Inventory.tres")


func _ready():
	inventory.connect("itemsChanged", self, "refresh_items")


func format_id(id:String) -> String:
	var formattedName = id
	# Replacing underscores with spaces
	while formattedName.find("_"):
		formattedName.replace("_", " ")
	# Removing text between bars
	var startHidden = formattedName.find("|")
	var endHidden = formattedName.find_last("|")
	var i = startHidden
	while i < endHidden:
		formattedName.replace(formattedName[i], "")
		i += 1

	# Finishing up
	print(formattedName)
	return formattedName


func refresh_items():
	for c in slots.get_children():
		c.queue_free()

	for i in inventory.items:
		var newSlot = slot.instance()
		slots.add_child(newSlot)
		var itemName = format_id(i.id)
		newSlot.setup(itemName, i.amount)


func _input(event):
	if Input.is_key_pressed(KEY_P):
		var items_ = [
			"cheese",
			"health_potion"
		]
		items_.shuffle()
		inventory.add_item(items_.pop_front(), 1)

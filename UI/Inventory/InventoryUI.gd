extends Control

onready var slots = $CenterContainer/Slots
onready var slider = $Slider

var slot = preload("res://UI/Inventory/Slot.tscn")
var inventory = preload("res://UI/Inventory/Inventory.tres")


func _ready():
	inventory.connect("itemsChanged", self, "refresh_items")


func refresh_items():
	for c in slots.get_children():
		c.queue_free()

	for i in inventory.items:
		var newSlot = slot.instance()
		slots.add_child(newSlot)
		newSlot.setup(i.id.replace("_", " "), i.amount)
		newSlot.connect("hovering", self, "_on_slot_hover")


func _on_slot_hover(hoveredSlot:Control):
	print("oi")
	slider.position.y = hoveredSlot.rect_global_position.y


func _input(_event):
	if Input.is_key_pressed(KEY_P):
		var items_ = [
			"Cheese",
			"Health_Potion",
			"Sandwhich"
		]
		items_.shuffle()
		inventory.add_item(items_.pop_front(), 1)

extends Control

onready var slots = $VBox/Slots

var inventory = preload("res://UI/Inventory/Inventory.tres")
var selectedSlot = 0

func _ready():
	inventory.maxSlots = slots.get_child_count()
	inventory.connect("itemsChanged", self, "refresh_items")
	# Connected the pressed signal of buttons
	for slot in slots.get_children():
		slot.connect("selected", self, "_on_button_pressed")


func refresh_items():
	for slot in slots.get_children():
		if slot.get_index() > inventory.items.size()-1:
			return
		var id = inventory.items[slot.get_index()]
		if id == null:
			continue
		var item = inventory.get_item(id)
		slot.clear()
		slot.setup(item.texture, id)


func _on_button_pressed(button:TextureButton):
	print(button.item)


func _input(_event):
	randomize()
	if Input.is_key_pressed(KEY_P):
		var items_ = [
			"Cheese",
			"Health_Potion",
			"Sandwich",
			"Revolver"
		]
		items_.shuffle()
		inventory.add_item(items_.pop_front())


extends Control

onready var slots = $VBox/Slots

var inventory = preload("res://UI/Inventory/Inventory.tres")
var selectedSlot = 0
var movingSlot:TextureButton

func _ready():
	inventory.maxSlots = slots.get_child_count()
	inventory.connect("itemsChanged", self, "refresh_items")
	# Connected the pressed signal of buttons
	for slot in slots.get_children():
		slot.connect("selected", self, "_on_button_pressed")


func _process(delta):
	if movingSlot:
		movingSlot.rect_position.x = get_local_mouse_position().x-8
		var hotbarBegin = slots.get_child(0).rect_global_position.x
		var hotbarEnd = slots.get_child_count()*18
		hotbarEnd += slots.get_child_count()+hotbarBegin
		movingSlot.rect_position.x = clamp(
			movingSlot.rect_position.x,
			hotbarBegin,
			hotbarEnd-7
		)
		movingSlot.rect_position.y = lerp(
			movingSlot.rect_position.y,
			get_viewport_rect().end.y-16*3,
			8*delta
		)

func _on_button_pressed(button:TextureButton):
	if movingSlot:
		remove_child(movingSlot)
		slots.add_child(movingSlot)
		slots.move_child(movingSlot, button.get_index())
		movingSlot = null
	else:
		slots.remove_child(button)
		movingSlot = button
		movingSlot.rect_position.y = get_viewport_rect().end.y-21
		add_child(movingSlot)


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


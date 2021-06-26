extends Control

onready var slots = $CenterContainer/Slots
onready var slider = $Slider

var slot = preload("res://UI/Inventory/Slot.tscn")
var inventory = preload("res://UI/Inventory/Inventory.tres")

onready var sliderTargetY = slider.position.y
var currentSelectedSlot = null


func _ready():
	inventory.connect("itemsChanged", self, "refresh_items")


func _process(delta):
	slider.position.y = lerp(slider.position.y, sliderTargetY, 15*delta)
	if currentSelectedSlot:
		currentSelectedSlot.rect_global_position.y = slider.position.y


func refresh_items():
	for c in slots.get_children():
		c.queue_free()

	for i in inventory.items:
		var newSlot = slot.instance()
		slots.add_child(newSlot)
		newSlot.setup(i.id.replace("_", " "), i.amount)
		newSlot.connect("hovering", self, "_on_slot_hover")
		newSlot.connect("move", self, "_on_slot_rearrange")


func _on_slot_rearrange(rearrangeSlot:TextureButton):
	if !currentSelectedSlot:
		currentSelectedSlot = rearrangeSlot

		slots.remove_child(currentSelectedSlot)
		add_child(currentSelectedSlot)
		currentSelectedSlot.rect_position.x = 94
		currentSelectedSlot.disabled = true
		currentSelectedSlot.mouse_filter = Control.MOUSE_FILTER_IGNORE
		currentSelectedSlot.modulate.a = .5
	else:
		remove_child(currentSelectedSlot)
		slots.add_child(currentSelectedSlot)
		slots.move_child(currentSelectedSlot, rearrangeSlot.get_index()+1)
		currentSelectedSlot.disabled = false
		currentSelectedSlot.mouse_filter = Control.MOUSE_FILTER_STOP
		currentSelectedSlot.modulate.a = 1

		currentSelectedSlot = null


func _on_slot_hover(hoveredSlot:Control):
	sliderTargetY = hoveredSlot.rect_global_position.y


func _input(_event):
	if Input.is_key_pressed(KEY_P):
		var items_ = [
			"Cheese",
			"Health_Potion",
			"Sandwich"
		]
		items_.shuffle()
		inventory.add_item(items_.pop_front(), 1)

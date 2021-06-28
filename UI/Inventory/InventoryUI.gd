extends Control

onready var slots = $Center/HBox/VBox/BackGround/Slots
onready var slotsBG = $Center/HBox/VBox/BackGround
onready var slider = $Slider
onready var itemViewer = $Center/HBox/InfoViewer/InfoViewerBG/ItemTexture
onready var clickSFX = $Click

var slot = preload("res://UI/Inventory/Slot.tscn")
var inventory = preload("res://UI/Inventory/Inventory.tres")

onready var sliderTargetY = slider.position.y
var currentSelectedSlot = null
var currentSelectedItem = null

signal inventory_toggled

func _ready():
	inventory.connect("itemsChanged", self, "refresh_items")


func _process(delta):
	slider.position.y = lerp(slider.position.y, sliderTargetY, 15*delta)
	if currentSelectedSlot:
		currentSelectedSlot.rect_global_position.y = slider.position.y
		currentSelectedSlot.rect_global_position.x = lerp(
			currentSelectedSlot.rect_global_position.x,
			slotsBG.rect_global_position.x + slotsBG.texture.get_width(),
			10*delta
			)


func refresh_items():
	for c in slots.get_children():
		c.queue_free()

	for i in inventory.items:
		var newSlot = slot.instance()
		slots.add_child(newSlot)
		newSlot.setup(i.id.replace("_", " "), i.amount, i.id)
		newSlot.connect("hovering", self, "_on_slot_hover")
		newSlot.connect("move", self, "_on_slot_rearrange")


func _on_slot_rearrange(rearrangeSlot:TextureButton):
	if !currentSelectedSlot:
		currentSelectedSlot = rearrangeSlot
		currentSelectedItem = rearrangeSlot.get_index()

		slots.remove_child(currentSelectedSlot)
		add_child(currentSelectedSlot)
		currentSelectedSlot.rect_position.x = slotsBG.rect_global_position.x + slotsBG.texture.get_width()/2
		currentSelectedSlot.disabled = true
		currentSelectedSlot.mouse_filter = Control.MOUSE_FILTER_IGNORE
		currentSelectedSlot.modulate.a = .5
	else:
		remove_child(currentSelectedSlot)
		slots.add_child(currentSelectedSlot)
		slots.move_child(currentSelectedSlot, rearrangeSlot.get_index())
		currentSelectedSlot.disabled = false
		currentSelectedSlot.mouse_filter = Control.MOUSE_FILTER_STOP
		currentSelectedSlot.modulate.a = 1

		inventory.move_item(currentSelectedItem, rearrangeSlot.get_index()-1)

		currentSelectedSlot = null


func _on_slot_hover(hoveredSlot:Control):
	sliderTargetY = hoveredSlot.rect_global_position.y
	itemViewer.texture = inventory.itemMap[hoveredSlot.item].texture
	clickSFX.play()


func _input(_event):
	if Input.is_key_pressed(KEY_P):
		var items_ = [
			"Cheese",
			"Health_Potion",
			"Sandwich"
		]
		items_.shuffle()
		inventory.add_item(items_.pop_front(), 1)

	if Input.is_action_just_pressed("inventory"):
		visible = !visible
		emit_signal("inventory_toggled", !visible)

extends Control

onready var slots = $VBox/Slots
onready var slotSelector = $SlotSelector

var inventory = preload("res://UI/Inventory/Inventory.tres")
var movingSlot:TextureButton
var oldSlotIndex = -1
var slotSelectorTarget = 0

func _ready():
	inventory.maxSlots = slots.get_child_count()
	inventory.connect("itemsChanged", self, "refresh_items")
	# Connected the pressed signal of buttons
	for slot in slots.get_children():
		slot.connect("selected", self, "_on_button_pressed")
		slot.connect("mouse_entered", self, "_on_mouse_entered")
		slot.connect("mouse_exited", self, "_on_mouse_exited")

	refresh_items()
	set_slot_cursor_position()


func _process(delta):
	slotSelector.rect_position.x = lerp(slotSelector.rect_position.x, slotSelectorTarget, 20*delta)
	set_slot_cursor_position()

	if movingSlot:
		var movingSlotTexWidth = movingSlot.texture_pressed.get_width()
		movingSlot.rect_position.x = get_local_mouse_position().x-(movingSlotTexWidth/2)
		var hotbarBegin = slots.get_child(0).rect_global_position.x
		var hotbarEnd = slots.get_child_count()*movingSlotTexWidth
		hotbarEnd += slots.get_child_count()+hotbarBegin
		# Clamping the position of the moving slot to stay within the bounds of the hotbar
		movingSlot.rect_position.x = clamp(movingSlot.rect_position.x, hotbarBegin, hotbarEnd-7)
		# Moving the slot to it's final y position
		movingSlot.rect_position.y = lerp(movingSlot.rect_position.y, get_viewport_rect().end.y-16*3, 8*delta)


func _on_button_pressed(button:TextureButton):
	if movingSlot:
		remove_child(movingSlot)
		slots.add_child(movingSlot)
		slots.move_child(movingSlot, button.get_index())
		inventory.move_item(oldSlotIndex, movingSlot.get_index())
		refresh_items()
		movingSlot = null
	else:
		inventory.selectedSlot = clamp(inventory.selectedSlot-1, 0, INF)
		oldSlotIndex = button.get_index()
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

		var tierColor = GameManager.itemManager.tierColors[inventory.itemMap[id].rarity]

		slot.clear()
		slot.setup(item.texture, id, tierColor)


func set_slot_cursor_position():
	# Positioning the slot section sprite
	var slotTexWidth = slots.get_child(0).texture_pressed.get_width()
	var hotbarBegin = slots.get_child(0).rect_global_position.x-1
	slotSelectorTarget = inventory.selectedSlot*slotTexWidth
	slotSelectorTarget += inventory.selectedSlot+hotbarBegin
	slotSelectorTarget += (inventory.selectedSlot*4)-inventory.selectedSlot


func _input(event):
	randomize()
	if Input.is_key_pressed(KEY_P):
		var items_ = inventory.itemMap.keys()
		items_.shuffle()
		inventory.add_item(items_.pop_front())

	# Slot scrolling
	if event.is_action_released("hotbar_scroll_left"):
		inventory.selectedSlot = wrapi(inventory.selectedSlot-1,
								0, slots.get_child_count())
	if event.is_action_released("hotbar_scroll_right"):
		inventory.selectedSlot = wrapi(inventory.selectedSlot+1,
								0, slots.get_child_count())
	# Selecting the slot with numbers
	for key in range(KEY_1, KEY_1+slots.get_child_count()):
		if Input.is_key_pressed(key):
			inventory.selectedSlot = key-KEY_1


func _on_mouse_entered():
	GameManager.editingInventory = true

func _on_mouse_exited():
	GameManager.editingInventory = false

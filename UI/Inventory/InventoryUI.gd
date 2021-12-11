extends Control

onready var slots = $HBox/Slots
onready var slotSelector = $SlotSelector
#onready var itemName = $VBox/ItemName

var inventory = preload("res://UI/Inventory/Inventory.tres")
var playerData = preload("res://Entities/Player/Player.tres")
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
	slotSelector.rect_position.x = slots.rect_position.x+slots.rect_size.x-slotSelector.texture.get_width()+1
	slotSelector.rect_position.y = lerp(slotSelector.rect_position.y, slotSelectorTarget, 20*delta)
	set_slot_cursor_position()

#	inventory.allowSlotChange = playerData.mode == playerData.DEFAULT_MODE
	slotSelector.visible = inventory.allowSlotChange

	if movingSlot:
		var movingSlotTexHeight = movingSlot.texture_pressed.get_height()
		movingSlot.rect_position.y = Utils.get_local_mouse_position(self).y-(movingSlotTexHeight/2)
		var hotbarBegin = slots.get_child(0).rect_global_position.y
		var hotbarEnd = slots.get_child_count()*movingSlotTexHeight
		hotbarEnd += slots.get_child_count()+hotbarBegin
		# Clamping the position of the moving slot to stay within the bounds of the hotbar
		movingSlot.rect_position.y = clamp(movingSlot.rect_position.y, hotbarBegin, hotbarEnd-7)
		# Moving the slot to it's final y position
		movingSlot.rect_position.x = lerp(movingSlot.rect_position.x, 48, 8*delta)


func _on_button_pressed(button:TextureButton):
	if movingSlot:
		add_moving_slot_back(button.get_index())
		refresh_items()
	else:
		inventory.selectedSlot = clamp(inventory.selectedSlot-1, 0, INF)
		oldSlotIndex = button.get_index()
		slots.remove_child(button)
		movingSlot = button
		movingSlot.rect_position.y = get_viewport_rect().end.y-21
		add_child(movingSlot)


func add_moving_slot_back(index):
	remove_child(movingSlot)
	slots.add_child(movingSlot)
	slots.move_child(movingSlot, index)
	inventory.move_item(oldSlotIndex, movingSlot.get_index())
	movingSlot = null
	inventory.selectedSlot = index


func refresh_items():
	for slot in slots.get_children():
		if slot.get_index() > inventory.items.size()-1:
			return
		var item = inventory.items[slot.get_index()]
		if item == null:
			slot.clear()
			continue
		
		slot.clear()
		slot.setup(item.slotTexture, item.key)


func set_slot_cursor_position():
	# Positioning the slot section sprite
	slotSelectorTarget = slots.get_child(inventory.selectedSlot).rect_position.y-1


func _input(event):
	randomize()

	# Slot scrolling
	if !playerData.isDead and !GameManager.inGUI:
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

		if event.is_action_pressed("drop_item"):
			var item = inventory.items[inventory.selectedSlot]
			if item == null:
				return

			# Spawning the item
			var itemManager = ItemManagement.new()
			var newItem = itemManager.create_item(item.key, true)
			newItem.global_position = playerData.playerObject.global_position+Vector2(0, -8)
			GameManager.spawnManager.spawn_object(newItem)

			inventory.remove_item(inventory.selectedSlot)

	# Item moving for controller
#	if event.is_action_pressed("move_item"):
#		_on_button_pressed(slots.get_child(inventory.selectedSlot))

func _on_mouse_entered():
	GameManager.editingInventory = true

func _on_mouse_exited():
	GameManager.editingInventory = false

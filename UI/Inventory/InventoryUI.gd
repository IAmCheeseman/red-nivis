extends Control

onready var slots = $HBox/Slots
onready var slotSelector = $SlotSelector
#onready var itemName = $VBox/ItemName

var inventory = preload("res://UI/Inventory/Inventory.tres")
var playerData = preload("res://Entities/Player/Player.tres")
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
	update_rp_gun()


func _process(delta):
	slotSelector.rect_position.x = slots.rect_position.x+slots.rect_size.x-slotSelector.texture.get_width()+1
	slotSelector.rect_position.y = lerp(slotSelector.rect_position.y, slotSelectorTarget, 20*delta)
	var currentSlot = slots.get_child(inventory.selectedSlot)
	currentSlot.rect_scale = currentSlot.rect_scale.move_toward(Vector2.ONE * 1.2, 5 * delta)
	currentSlot.modulate = Color.white
	for i in slots.get_children():
		if i == currentSlot: continue
		i.rect_scale = i.rect_scale.move_toward(Vector2.ONE, 5 * delta)
		i.modulate = Color.darkgray
	set_slot_cursor_position()


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
		var updated = false
		if event.is_action_released("hotbar_scroll_left"):
			inventory.selectedSlot = wrapi(inventory.selectedSlot-1,
									 0, slots.get_child_count())
			updated = true
		if event.is_action_released("hotbar_scroll_right"):
			inventory.selectedSlot = wrapi(inventory.selectedSlot+1,
									0, slots.get_child_count())
			updated = true
		# Selecting the slot with numbers
		for key in range(KEY_1, KEY_1+slots.get_child_count()):
			if Input.is_key_pressed(key):
				inventory.selectedSlot = key-KEY_1
				updated = true
		
		if !updated: return
		update_rp_gun()

func update_rp_gun() -> void:
	var slot = slots.get_child(inventory.selectedSlot)
	if slot.item == "": GameManager.rpGun = "No Gun"
	else: GameManager.rpGun = ItemMap.ITEMS[slot.item].name
	GameManager.update_rp()


func _on_mouse_entered():
	GameManager.editingInventory = true

func _on_mouse_exited():
	GameManager.editingInventory = false

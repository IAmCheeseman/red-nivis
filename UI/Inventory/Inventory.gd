extends Resource
class_name Inventory

# Inventory stuff
export var maxSlots:int = 2
var items:Array = []
var selectedSlot:int = 0 setget _on_selected_slot_changed

# Item map
#var itemMapR = preload("res://UI/Inventory/ItemMap.tres")
var itemMap = ItemMap.ITEMS.duplicate()
var allowSlotChange = true

# Signals
signal itemsChanged
signal itemDeleted
signal itemAdded
signal selectedSlotChanged


func _init():
	setup()

func setup():
	items.clear()
	for slot in maxSlots:
		items.append(null)
	randomize()
	add_item('pump-shotgun')


func has_space() -> bool:
	for item in items:
		if item == null: return true
	return false


func has_item(id:String) -> bool:
	var hasItem = false
	for i in items:
		hasItem = i.key == id
		if hasItem: break
	return hasItem


func get_item(id:String):
	if id.is_valid_integer():
		return null
	push_error("ITEM DOES NOT EXIST: %s" % id)


func filter_items(id:String):
	var filteredItems = []
	for item in items:
		if item.id == id:
			filteredItems.append(item)
	return filteredItems


func move_item(from:int, to:int):
	var movedItem = items[from]
	items.remove(from)
	items.insert(to, movedItem)
	emit_signal("itemsChanged")


func is_empty() -> bool:
	for item in items:
		if item:
			return false
	return true


func remove_item(id):
	if id is String:
		if !has_item(id):
			return false
		for item in items.size():
			if !items[item] is Dictionary: continue
			if items[item].key == id:
				items[item] = null
	elif id is int:
		items[id] = null

	emit_signal("itemsChanged")
	emit_signal("itemDeleted", id)

	return true



func add_item(id):
	if !has_space(): return
	items[items.find(null)] = itemMap[id]
	emit_signal("itemsChanged")
	emit_signal("itemAdded", id)


func destroy_item(id:String, amount:int):
	# Filtering out all the items I don't need
	if !has_item(id):
		return
	for i in amount:
		items.remove(items.find(id))
	# Finishing up
	emit_signal("itemsChanged")
	emit_signal("itemDeleted", id)


func _on_selected_slot_changed(value):
	if allowSlotChange:
		selectedSlot = value
		emit_signal("selectedSlotChanged")






extends Resource
class_name Inventory

# Inventory stuff
export var maxSlots:int = 6
var items:Array = []
var selectedSlot:int = 0 setget _on_selected_slot_changed

# Item map
var itemMapR = preload("res://UI/Inventory/ItemMap.tres")
var itemMap = itemMapR.items

# Signals
signal itemsChanged
signal itemDeleted
signal itemAdded
signal selectedSlotChanged


func _init():
	for slot in maxSlots:
		items.append(null)
	add_item("Pistol")


func check_existence(id:String) -> bool:
	if itemMap.has(id):
		return true
	return false


func has_space() -> bool:
	for item in items:
		if item == null: return true
	return false


func has_item(id:String) -> bool:
	for item in items:
		if item == id: return true
	return false


func get_item(id:String):
	if check_existence(id):
		return itemMap[id]
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


func add_item(id:String):
	for item in items.size():
		if items[item] == null:
			items[item] = id
			break

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
	selectedSlot = value
	emit_signal("selectedSlotChanged")






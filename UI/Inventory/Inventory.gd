extends Resource
class_name Inventory


# Inventory stuff
export var maxSlots:int = 2
var items:Array = []
var selectedSlot:int = 0 setget _on_selected_slot_changed

# Item map
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
	clear()
	randomize()
	add_item('pistol')


func has_space() -> bool:
	return items.has(null)


func has_item(id:String) -> bool:
	for i in items:
		if i.itemData.key == id:
			return true
	return false


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


func clear() -> void:
	items = [null, null]


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
			if items[item].itemData.key == id:
				items[item] = null
	elif id is int:
		items[id] = null

	emit_signal("itemsChanged")
	emit_signal("itemDeleted", id)

	return true



func add_item(id):
	if !has_space(): return
	items[items.find(null)] = {"itemData" : itemMap[id], "ammoLeft" : -1}
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






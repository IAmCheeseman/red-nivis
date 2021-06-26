extends Resource
class_name Inventory

# Inventory stuff
export var maxSlots = 8
var items = []

# Item map
var itemMapR = preload("res://UI/Inventory/ItemMap.gd")
var itemMap = itemMapR.items

# Signals
signal itemsChanged
signal itemDeleted
signal itemAdded

# So I can make sure the item actually exists before doing anything.
func check_if_exists(item:String) -> bool:
	if itemMap.has(item):
		return true
	return false


func add_item(item:String, amount:int):
	# Checking if the item can actually be added.
	if items.size() > maxSlots:
		return
	if !check_if_exists(item):
		push_error("ITEM DOES NOT EXIST: %s" % item)
		return
	
	# Adding the item.
	items.append({
		"id" : item,
		"amount" : amount
    })

	emit_signal("itemsChanged")
	emit_signal("itemAdded", item)


func destroy_item(item:String, amount:int):
	emit_signal("itemDeleted", item)


extends Resource
class_name Inventory

# Inventory stuff
export var maxSlots = 8
var items = []

# Item map
var itemMapR = preload("res://UI/Inventory/ItemMap.tres")
var itemMap = itemMapR.items

# Signals
signal itemsChanged
signal itemDeleted
signal itemAdded


# Sorting class
class sortByAmount:
	static func sort_descending(a, b):
		if a.amount > b.amount:
			return true
		return false


func check_existence(id:String) -> bool:
	if itemMap.has(id):
		return true
	return false


func filter_items(id:String):
	var filteredItems = []
	for item in items:
		if item.id == id:
			filteredItems.append(item)
	return filteredItems


func move_item(from:int, to:int):
	var movedItem = items[from].duplicate()
	items.remove(from)
	items.insert(to, movedItem)


func add_item(id:String, amount:int):
	# Checking if the item can actually be added.
	var filteredItems = filter_items(id)

	# Making sure all stacks are not full.
	var stacksFull = true
	for i in filteredItems:
		if i.amount < itemMap[id].maxStackSize:
			stacksFull = false
			break
	if items.size() >= maxSlots and stacksFull:
		return
	if !check_existence(id):
		push_error("ITEM DOES NOT EXIST: %s" % id)
		return

	var maxStackSize = itemMap[id].maxStackSize

	# Adding items
	if filteredItems.size() != 0:
		for slot in filteredItems:
			if amount <= 0:
				break
			var amountRemaining = maxStackSize-slot.amount
			slot.amount = min(slot.amount+amount, maxStackSize)
			amount -= amountRemaining
	# Adding any stacks that need to be added
	while amount > 0:
		items.append({
			"id" : id,
			"amount" : min(amount, maxStackSize)
		})
		amount -= maxStackSize

	emit_signal("itemsChanged")
	emit_signal("itemAdded", id)


func destroy_item(id:String, amount:int) -> bool:
	# Filtering out all the items I don't need
	var filteredItems = filter_items(id)
	# Stopping if there's no items to destroy
	if filteredItems.size() == 0:
		return false

	# Sorting the items by the amount from highest to lowest
	# Then going through and removing as many stacks as I need.
	filteredItems.sort_custom(sortByAmount, "sort_descending")

	while amount != 0 :
		var selectedStack = filteredItems.pop_front()
		var amountRemaining = amount - selectedStack.amount
		selectedStack.amount -= amount
		if selectedStack.amount <= 0:
			items.remove(selectedStack)
		amount = amountRemaining

	# Finishing up
	emit_signal("itemsChanged")
	emit_signal("itemDeleted", id)
	return true


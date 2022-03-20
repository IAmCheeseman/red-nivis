extends Node2D

onready var shop = $CanvasLayer
onready var playerInven = find_node("PlayerWeapons")
onready var shopInven = find_node("ShopWeapons")
onready var nsWarning = find_node("NoSelectionWarning")
onready var naiWarning = find_node("NoAvailableItemsWarning")

var inventory = preload("res://UI/Inventory/Inventory.tres")
var shopData = preload("res://Entities/NPC/Birb/TradingPostData.tres")

var selectedItem: CustomButton


func _ready() -> void:
	for i in inventory.items:
		if i is Dictionary:

			if shopData.tradedWeapons.has(i.itemData.key): continue
			shopData.tradedWeapons.append(i.itemData.key)
	open_shop(false)


func update_items(items:=inventory.items, par:=playerInven, connection:="_on_player_weapon_chosen") -> void:
	# Removing the items
	Utils.free_children(par)
	for i in items:
		if !i is Dictionary: return
		var j = i
		if j.has("itemData"): j = j.itemData
		
		# Adding the item to the shop
		var newButton = preload("res://Entities/NPC/Birb/WeaponButton.tscn").instance()
		par.add_child(newButton)
		newButton.toggle_mode = true
		newButton.setup(load(j.slotTexture), j.name, j.key)
		newButton.connect("pressed", self, connection, [newButton])


func open_shop(open:=true) -> void:
	if GameManager.inGUI == open: return
	# Updating shop data
	update_items()
	Utils.free_children(shopInven)
	_on_player_weapon_chosen(null)
	nsWarning.show()
	naiWarning.hide()
	yield(TempTimer.idle_frame(self), "timeout")
	GameManager.inGUI = open
	
	# Opening the shop
	for i in shop.get_children():
		i.visible = open


func _on_player_weapon_chosen(button: CustomButton) -> void:
	# Unselecting every other button
	for i in playerInven.get_children():
		if i != button:
			i.pressed = false
	# Selecting the item
	selectedItem = button
	
	if button:
		# Hiding any warnings
		nsWarning.hide()
		naiWarning.hide()
		
		if inventory.items[button.get_index()].itemData.key == "pistol":
			nsWarning.hide()
			naiWarning.show()
			update_items([], shopInven, "swap_items")
			return
		
		# Updating the shop items
		var items = find_same_tier_items(inventory.items[button.get_index()].itemData.tier)
		update_items(items, shopInven, "swap_items")
		
		# Removing the shop items if the button is unselected
		if !button.pressed:
			update_items()
			nsWarning.show()
			naiWarning.hide()
			Utils.free_children(shopInven)
		# If there's no shop items, display a message
		if items.size() == 0:
			nsWarning.hide()
			naiWarning.show()


func swap_items(button: CustomButton) -> void:
	# Swapping the items
	inventory.remove_item(selectedItem.itemID)
	inventory.add_item(button.itemID)
	
	# Removing the items from the shop
	shopData.tradedWeapons.append(selectedItem.itemID)
	for b in button.get_parent().get_children():
		shopData.tradedWeapons.append(b.itemID)
	selectedItem = null
	
	# Refreshing everything
	update_items()
	Utils.free_children(shopInven)
	nsWarning.show()
	naiWarning.hide()
	
	Achievement.unlock("BIRB")


# Loops through every item in the game looking for
# items in the same tier.
func find_same_tier_items(tier: int) -> Array:
	var items := []
	
	for key in ItemMap.ITEMS.keys():
		var item = ItemMap.ITEMS[key]
		var k_tier = item.tier
		if k_tier == tier and !key in shopData.tradedWeapons:
			items.append(item)
	
	return items


func _input(event: InputEvent) -> void:
	# Close the shop
	if event.is_action_pressed("ui_cancel"):
		open_shop(false)
		Utils.free_children(shopInven)

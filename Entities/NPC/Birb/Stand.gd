extends Node2D

onready var birb = $Birb
onready var shop = $CanvasLayer
onready var playerInven = find_node("PlayerWeapons")
onready var naiWarning = find_node("NoAvailableItemsWarning")
onready var tradeButton = find_node("Trade")

var inventory = preload("res://UI/Inventory/Inventory.tres")
var shopData = preload("res://Entities/NPC/Birb/TradingPostData.tres")

var selectedItem: CustomButton

var tradableItems: Array


func _ready() -> void:
	for i in inventory.items:
		if i is Dictionary:

			if shopData.tradedWeapons.has(i.itemData.key): continue
			shopData.tradedWeapons.append(i.itemData.key)
	open_shop(false)

### Updates the item lists
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

### Initializes the shop gui
func open_shop(open:=true) -> void:
	if GameManager.inGUI == open: return
	
	# Updating shop data
	update_items()
	_on_player_weapon_chosen(null)
	naiWarning.hide()
#	yield(TempTimer.idle_frame(self), "timeout")
	GameManager.inGUI = open
	
	# Opening the shop
	for i in shop.get_children():
		i.visible = open

### Called when the player chooses a weapon
func _on_player_weapon_chosen(button: CustomButton) -> void:
	# Deselecting every other button
	for i in playerInven.get_children():
		if i != button:
			i.pressed = false
	
	# Selecting the item
	selectedItem = button
	tradeButton.hide()
	
	if button:
		# Hiding any warnings
		naiWarning.hide()
		if inventory.items[button.get_index()].itemData.key == "pistol":
			naiWarning.show()
			return
		tradeButton.show()
		
		# Updating the shop items
		tradableItems = find_same_tier_items(inventory.items[button.get_index()].itemData.tier)
		tradableItems.shuffle()
		
		# Making sure that you can't get the debug weapon, the pistol, or your current weapon.
		for j in tradableItems.size():
			var i = tradableItems.size() - j
			if tradableItems[i - 1].key in ["tw", "pistol", selectedItem.itemID]:
				tradableItems.remove(i - 1)


### Called when the player clicks the trade button
func swap_items() -> void:
	if naiWarning.visible:
		return
	
	# Swapping the items
	inventory.remove_item(selectedItem.itemID)
	var item = GameManager.itemManager.create_item(tradableItems.pop_front().key, true)
	item.global_position = birb.global_position
	GameManager.spawnManager.spawn_object(item)
	
	# Refreshing everything
	update_items()
	naiWarning.hide()
	
	Achievement.unlock("BIRB")
	
	open_shop(false)
	
	birb.defaultDialog = "Empty"
	birb.disconnect("dialog_finished", self, "open_shop")


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
	if !GameManager.inGUI or !$CanvasLayer/Prompts.visible: return
	
	# Close the shop
	for i in ["ui_cancel", "interact"]:
		if event.is_action_pressed(i):
			open_shop(false)

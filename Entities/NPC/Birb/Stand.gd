extends Node2D

onready var birb = $Birb

var inventory = preload("res://UI/Inventory/Inventory.tres")

func swap_items() -> void:
	if birb.defaultDialog == "Introduction":
		birb.defaultDialog = "Trade"
		return

		
	# Swapping the items
	var playerItem = inventory.items[inventory.selectedSlot].itemData
	var validItems = find_same_tier_items(playerItem.tier)
	validItems.shuffle()

	inventory.remove_item(playerItem.key)

	var item = GameManager.itemManager.create_item(validItems.pop_front().key, true)
	item.global_position = birb.global_position
	GameManager.spawnManager.spawn_object(item)
		
	Achievement.unlock("BIRB")	
	birb.defaultDialog = "Empty"


# Loops through every item in the game looking for
# items in the same tier.
func find_same_tier_items(tier: int) -> Array:
	var items := []
	
	for key in ItemMap.ITEMS.keys():
		var item = ItemMap.ITEMS[key]
		var k_tier = item.tier
		if k_tier == tier:
			items.append(item)
	
	return items

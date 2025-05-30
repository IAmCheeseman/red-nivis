extends Resource
class_name ItemManagement

var tierColors = {
	"common" : Color("#ffffff"),
	"uncommon" : Color("#e49b35"),
	"rare" : Color("#5bb031")
}

enum {COMMON, UNCOMMON, RARE}

#var itemDropped = preload("res://Items/DroppedItem.tscn")


func convert_tier_to_str(tier: int):
	match tier:
		COMMON: return "common"
		UNCOMMON: return "uncommon"
		RARE: return "rare"



func create_item(item, withForce: bool=false):
	if item:
		var newItem = load("res://Items/DroppedItem.tscn").instance()
		newItem.item = ItemMap.ITEMS[item]
		if withForce:
			var force = Vector2(rand_range(-.25, .25), -1).normalized()*70
			newItem.apply_central_impulse(force)
		return newItem

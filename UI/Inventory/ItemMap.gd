extends Resource
class_name ItemMap


func get_item(id:String):
	if !items.has(id):
		push_error("ITEM DOES NOT EXIST: %s" % id)
		return
	return items[id]


var items = {

	"cheese" : {
				"texture" : preload("res://Items/Consumables/Cheese.png"),
				"maxStackSize" : 5
	},

	"health_potion" : {
				"texture" : preload("res://Items/Consumables/HealthPotion.png"),
				"maxStackSize" : 3
	}
}

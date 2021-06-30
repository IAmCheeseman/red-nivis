extends Resource
class_name ItemMap


func get_item(id:String):
	if !items.has(id):
		push_error("ITEM DOES NOT EXIST: %s" % id)
		return
	return items[id]


var items = {

	"Cheese" : {
				"texture" : preload("res://Items/Consumables/Cheese.png"),
				"maxStackSize" : 5
	},

	"Health_Potion" : {
				"texture" : preload("res://Items/Consumables/HealthPotion.png"),
				"maxStackSize" : 3
	},
	"Sandwich" : {
				"texture" : preload("res://Items/Consumables/SandWhich.png"),
				"maxStackSize" : 5
	}
}

var weapons = [
	"Chaingun",
	"LaserPistol",
	"LaserShotgun",
	"Minigun",
	"Pistol",
	"RedPistol",
	"NachoChip"
]

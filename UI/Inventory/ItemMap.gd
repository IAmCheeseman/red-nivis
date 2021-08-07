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
		"scene" : null,
		"script" : null,
		"rarity" : "common"
	},

	"Health_Potion" : {
		"texture" : preload("res://Items/Consumables/HealthPotion.png"),
		"scene" : null,
		"script" : null,
		"rarity" : "common"
	},

	"Sandwich" : {
		"texture" : preload("res://Items/Consumables/SandWhich.png"),
		"scene" : null,
		"script" : null,
		"rarity" : "common"
	},

	"Minigun" : {
		"texture" : preload("res://Items/Weapons/WeaponSprites/Minigun.png"),
		"scene" : preload("res://Items/Weapons/WeaponScenes/Minigun.tscn"),
		"script" : null,
		"rarity" : "legendary"
	},

	"Chaingun" : {
		"texture" : preload("res://Items/Weapons/WeaponSprites/Chaingun.png"),
		"scene" : preload("res://Items/Weapons/WeaponScenes/Chaingun.tscn"),
		"script" : null,
		"rarity" : "rare"
	},

	"Laser_Pistol" : {
		"texture" : preload("res://Items/Weapons/WeaponSprites/LaserPistol.png"),
		"scene" : preload("res://Items/Weapons/WeaponScenes/LaserPistol.tscn"),
		"script" : null,
		"rarity" : "uncommon"
	},

	"Laser_Shotgun" : {
		"texture" : preload("res://Items/Weapons/WeaponSprites/LaserShotgun.png"),
		"scene" : preload("res://Items/Weapons/WeaponScenes/LaserShotgun.tscn"),
		"script" : null,
		"rarity" : "uncommon"
	},

	"Pistol" : {
		"texture" : preload("res://Items/Weapons/WeaponSprites/Pistol.png"),
		"scene" : preload("res://Items/Weapons/WeaponScenes/Pistol.tscn"),
		"script" : null,
		"rarity" : "common"
	},

	"Shotgun" : {
		"texture" : preload("res://Items/Weapons/WeaponSprites/Shotgun.png"),
		"scene" : preload("res://Items/Weapons/WeaponScenes/Shotgun.tscn"),
		"script" : null,
		"rarity" : "common"
	},

	"Revolver" : {
		"texture" : preload("res://Items/Weapons/WeaponSprites/Revolver.png"),
		"scene" : preload("res://Items/Weapons/WeaponScenes/Revolver.tscn"),
		"script" : null,
		"rarity" : "common"
	},

	"Red_Pistol" : {
		"texture" : preload("res://Items/Weapons/WeaponSprites/RedPistol.png"),
		"scene" : preload("res://Items/Weapons/WeaponScenes/RedPistol.tscn"),
		"script" : null,
		"rarity" : "legendary"
	},

	"Nacho_Chip" : {
		"texture" : preload("res://Items/Weapons/WeaponSprites/NachoChip.png"),
		"scene" : preload("res://Items/Weapons/WeaponScenes/NachoChip.tscn"),
		"script" : null,
		"rarity" : "rare"
	},

	"Rocket_Launcher" : {
		"texture" : preload("res://Items/Weapons/WeaponSprites/RocketLauncher.png"),
		"scene" : preload("res://Items/Weapons/WeaponScenes/RocketLauncher.tscn"),
		"script" : null,
		"rarity" : "uncommon"
	},

	"Grenade_Launcher" : {
		"texture" : preload("res://Items/Weapons/WeaponSprites/GrenadeLauncher.png"),
		"scene" : preload("res://Items/Weapons/WeaponScenes/GrenadeLauncher.tscn"),
		"script" : null,
		"rarity" : "rare"
	}
}

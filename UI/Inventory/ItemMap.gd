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
		"script" : null
	},

	"Health_Potion" : {
		"texture" : preload("res://Items/Consumables/HealthPotion.png"),
		"scene" : null,
		"script" : null
	},

	"Sandwich" : {
		"texture" : preload("res://Items/Consumables/SandWhich.png"),
		"scene" : null,
		"script" : null
	},

	"Minigun" : {
		"texture" : preload("res://Items/Weapons/WeaponSprites/Minigun.png"),
		"scene" : preload("res://Items/Weapons/WeaponScenes/Minigun.tscn"),
		"script" : null
	},

	"Chaingun" : {
		"texture" : preload("res://Items/Weapons/WeaponSprites/Chaingun.png"),
		"scene" : preload("res://Items/Weapons/WeaponScenes/Chaingun.tscn"),
		"script" : null
	},

	"Laser_Pistol" : {
		"texture" : preload("res://Items/Weapons/WeaponSprites/LaserPistol.png"),
		"scene" : preload("res://Items/Weapons/WeaponScenes/LaserPistol.tscn"),
		"script" : null
	},

	"Laser_Shotgun" : {
		"texture" : preload("res://Items/Weapons/WeaponSprites/LaserShotgun.png"),
		"scene" : preload("res://Items/Weapons/WeaponScenes/LaserShotgun.tscn"),
		"script" : null
	},

	"Pistol" : {
		"texture" : preload("res://Items/Weapons/WeaponSprites/Pistol.png"),
		"scene" : preload("res://Items/Weapons/WeaponScenes/Pistol.tscn"),
		"script" : null
	},

	"Shotgun" : {
		"texture" : preload("res://Items/Weapons/WeaponSprites/Shotgun.png"),
		"scene" : preload("res://Items/Weapons/WeaponScenes/Shotgun.tscn"),
		"script" : null
	},

	"Revolver" : {
		"texture" : preload("res://Items/Weapons/WeaponSprites/Revolver.png"),
		"scene" : preload("res://Items/Weapons/WeaponScenes/Revolver.tscn"),
		"script" : null
	},

	"Red_Pistol" : {
		"texture" : preload("res://Items/Weapons/WeaponSprites/RedPistol.png"),
		"scene" : preload("res://Items/Weapons/WeaponScenes/RedPistol.tscn"),
		"script" : null
	},

	"Nacho_Chip" : {
		"texture" : preload("res://Items/Weapons/WeaponSprites/NachoChip.png"),
		"scene" : preload("res://Items/Weapons/WeaponScenes/NachoChip.tscn"),
		"script" : null
	},

	"Rocket_Launcher" : {
		"texture" : preload("res://Items/Weapons/WeaponSprites/RocketLauncher.png"),
		"scene" : preload("res://Items/Weapons/WeaponScenes/RocketLauncher.tscn"),
		"script" : null
	},

	"Grenade_Launcher" : {
		"texture" : preload("res://Items/Weapons/WeaponSprites/GrenadeLauncher.png"),
		"scene" : preload("res://Items/Weapons/WeaponScenes/GrenadeLauncher.tscn"),
		"script" : null
	}
}

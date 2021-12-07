extends Reference
class_name ItemMap

const ITEMS = {
	"pistol" : {
		"key" : "pistol",
		"name" : "Pistol",
		"scene" : preload("res://Items/Weapons/Scenes/Pistol.tscn"),
		"slotTexture" : preload("res://Items/Weapons/Sprites/Pistol.png")
	},
	"regular-shotgun" : {
		"key" : "regular-shotgun",
		"name" : "Shotgun",
		"scene" : preload("res://Items/Weapons/Scenes/Shotgun.tscn"),
		"slotTexture" : preload("res://Items/Weapons/Sprites/Shotgun.png")
	}
}

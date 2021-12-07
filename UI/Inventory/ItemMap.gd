extends Reference
class_name ItemMap

const ITEMS = {
	"pistol" : {
		"key" : "pistol",
		"name" : "Pistol",
		"tier" : ToolTipGenerator.TIERS.LAB,
		"scene" : preload("res://Items/Weapons/Scenes/Pistol.tscn"),
		"slotTexture" : preload("res://Items/Weapons/Sprites/Pistol.png")
	},
	"regular-shotgun" : {
		"key" : "regular-shotgun",
		"name" : "Pump Shotgun",
		"tier" : ToolTipGenerator.TIERS.CAVE,
		"scene" : preload("res://Items/Weapons/Scenes/Shotgun.tscn"),
		"slotTexture" : preload("res://Items/Weapons/Sprites/Shotgun.png")
	}
}

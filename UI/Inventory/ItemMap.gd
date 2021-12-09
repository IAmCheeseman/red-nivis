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
	"revolver" : {
		"key" : "revolver",
		"name" : "Revolver",
		"tier" : ToolTipGenerator.TIERS.LAB,
		"scene" : preload("res://Items/Weapons/Scenes/Revolver.tscn"),
		"slotTexture" : preload("res://Items/Weapons/Sprites/Revolver.png")
	},
	"pump-shotgun" : {
		"key" : "pump-shotgun",
		"name" : "Pump Shotgun",
		"tier" : ToolTipGenerator.TIERS.CAVE,
		"scene" : preload("res://Items/Weapons/Scenes/Shotgun.tscn"),
		"slotTexture" : preload("res://Items/Weapons/Sprites/Shotgun.png")
	},
	"assault-rifle" : {
		"key" : "assault-rifle",
		"name" : "Assault Rifle",
		"tier" : ToolTipGenerator.TIERS.DEEPLABS,
		"scene" : preload("res://Items/Weapons/Scenes/AssaultRifle.tscn"),
		"slotTexture" : preload("res://Items/Weapons/Sprites/AssaultRifle.png")
	}
}

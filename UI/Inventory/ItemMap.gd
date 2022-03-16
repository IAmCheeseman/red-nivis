extends Reference
class_name ItemMap

const ITEMS = {
	# LABS ITEMS
	"pistol" : {
		"key" : "pistol",
		"name" : "PISTOL_ITM",
		"tier" : ToolTipGenerator.TIERS.LAB,
		"scene" : "res://Items/Weapons/Scenes/Pistol.tscn",
		"slotTexture" : "res://Items/Weapons/Sprites/Pistol.png"
	},
	"revolver" : {
		"key" : "revolver",
		"name" : "REVOLVER_ITM",
		"tier" : ToolTipGenerator.TIERS.LAB,
		"scene" : "res://Items/Weapons/Scenes/Revolver.tscn",
		"slotTexture" : "res://Items/Weapons/Sprites/Revolver.png"
	},
	"ak-47" : {
		"key" : "ak-47",
		"name" : "AK47_ITM",
		"tier" : ToolTipGenerator.TIERS.LAB,
		"scene" : "res://Items/Weapons/Scenes/ak47.tscn",
		"slotTexture" : "res://Items/Weapons/Sprites/ak47.png"
	},
	"grenade-launcher" : {
		"key" : "grenade-launcher",
		"name" : "GRENADE_LAUNCHER_ITM",
		"tier" : ToolTipGenerator.TIERS.LAB,
		"scene" : "res://Items/Weapons/Scenes/GrenadeLauncher.tscn",
		"slotTexture" : "res://Items/Weapons/Sprites/GrenadeLauncher.png"
	},
	# CAVE ITEMS
	"pump-shotgun" : {
		"key" : "pump-shotgun",
		"name" : "PUMP_SHOTGUN_ITM",
		"tier" : ToolTipGenerator.TIERS.CAVE,
		"scene" : "res://Items/Weapons/Scenes/Shotgun.tscn",
		"slotTexture" : "res://Items/Weapons/Sprites/Shotgun.png"
	},
	"homing-boomerang" : {
		"key" : "homing-boomerang",
		"name" : "HOMING_BOOMERANG_ITM",
		"tier" : ToolTipGenerator.TIERS.CAVE,
		"scene" : "res://Items/Weapons/Scenes/HomingBoomerang.tscn",
		"slotTexture" : "res://Items/Weapons/Sprites/HomingBoomerang.png"
	},
	"flamethrower" : {
		"key" : "flamethrower",
		"name" : "FLAMETHROWER_ITM",
		"tier" : ToolTipGenerator.TIERS.CAVE,
		"scene" : "res://Items/Weapons/Scenes/FlameThrower.tscn",
		"slotTexture" : "res://Items/Weapons/Sprites/Flamethrower.png"
	},
	# DEEP LABS ITEMS
	"assault-rifle" : {
		"key" : "assault-rifle",
		"name" : "ASSAULT_RIFLE_ITM",
		"tier" : ToolTipGenerator.TIERS.DEEPLABS,
		"scene" : "res://Items/Weapons/Scenes/AssaultRifle.tscn",
		"slotTexture" : "res://Items/Weapons/Sprites/AssaultRifle.png"
	},
	"minigun" : {
		"key" : "minigun",
		"name" : "MINIGUN_ITM",
		"tier" : ToolTipGenerator.TIERS.DEEPLABS,
		"scene" : "res://Items/Weapons/Scenes/Minigun.tscn",
		"slotTexture" : "res://Items/Weapons/Sprites/Minigun.png"
	},
	"multishot-boomerang" : {
		"key" : "multishot-boomerang",
		"name" : "MULTISHOT_BOOMERANG_ITM",
		"tier" : ToolTipGenerator.TIERS.DEEPLABS,
		"scene" : "res://Items/Weapons/Scenes/MultishotBoomerang.tscn",
		"slotTexture" : "res://Items/Weapons/Sprites/MultishotBoomerang.png"
	},
	# FREEZERS ITEMS
	"j-laser" : {
		"key" : "j-laser",
		"name" : "J_LASER_ITM",
		"tier" : ToolTipGenerator.TIERS.FREEZERS,
		"scene" : "res://Items/Weapons/Scenes/JLaser.tscn",
		"slotTexture" : "res://Items/Weapons/Sprites/JLaser.png"
	},
	# TOXIC CAVERNS ITEMs
	"bullet-chainsaw" : {
		"key" : "bullet-chainsaw",
		"name" : "BULLET_CHAINSAW_ITM",
		"tier" : ToolTipGenerator.TIERS.TOXIC_CAVERNS,
		"scene" : "res://Items/Weapons/Scenes/BulletChainsaw.tscn",
		"slotTexture" : "res://Items/Weapons/Sprites/Chainsaw.png"
	},
	"vaporgat" : {
		"key" : "vaporgat",
		"name" : "VAPORGAT_ITM",
		"tier" : ToolTipGenerator.TIERS.TOXIC_CAVERNS,
		"scene" : "res://Items/Weapons/Scenes/Vaporgat.tscn",
		"slotTexture" : "res://Items/Weapons/Sprites/Vaporgat.png"
	},
}

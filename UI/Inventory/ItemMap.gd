extends Reference
class_name ItemMap

const ITEMS = {
	"tw" : {
		"key" : "tw",
		"name" : "Testing Weapon",
		"tier" : ToolTipGenerator.TIERS.LAB,
		"scene" : "res://Items/Weapons/Scenes/TestingWeapon.tscn",
		"slotTexture" : "res://Items/Weapons/Sprites/Pistol.png"
	},
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
	"laser-gun" : {
		"key" : "laser-gun",
		"name" : "LASER_GUN_ITM",
		"tier" : ToolTipGenerator.TIERS.LAB,
		"scene" : "res://Items/Weapons/Scenes/LaserGun.tscn",
		"slotTexture" : "res://Items/Weapons/Sprites/LaserGun.png"
	},
	"grenade-launcher" : {
		"key" : "grenade-launcher",
		"name" : "GRENADE_LAUNCHER_ITM",
		"tier" : ToolTipGenerator.TIERS.LAB,
		"scene" : "res://Items/Weapons/Scenes/GrenadeLauncher.tscn",
		"slotTexture" : "res://Items/Weapons/Sprites/GrenadeLauncher.png"
	},
	"shotgun" : {
		"key" : "shotgun",
		"name" : "SHOTGUN_ITM",
		"tier" : ToolTipGenerator.TIERS.LAB,
		"scene" : "res://Items/Weapons/Scenes/Shotgun.tscn",
		"slotTexture" : "res://Items/Weapons/Sprites/Shotgun.png"
	},
	"crossbow" : {
		"key" : "crossbow",
		"name" : "CROSSBOW_ITM",
		"tier" : ToolTipGenerator.TIERS.LAB,
		"scene" : "res://Items/Weapons/Scenes/Crossbow.tscn",
		"slotTexture" : "res://Items/Weapons/Sprites/Crossbow.png"
	},
	# CAVE ITEMS
	"fire-shotgun" : {
		"key" : "fire-shotgun",
		"name" : "FIRE_SHOTGUN_ITM",
		"tier" : ToolTipGenerator.TIERS.CAVE,
		"scene" : "res://Items/Weapons/Scenes/FireShotgun.tscn",
		"slotTexture" : "res://Items/Weapons/Sprites/FireShotgun.png"
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
	"tbpistol" : {
		"key" : "tbpistol",
		"name" : "TRIPLE_BARREL_PISTOL_ITM",
		"tier" : ToolTipGenerator.TIERS.CAVE,
		"scene" : "res://Items/Weapons/Scenes/TripleBarrelPistol.tscn",
		"slotTexture" : "res://Items/Weapons/Sprites/TripleBarrelPistol.png"
	},
	"laser-shotgun" : {
		"key" : "laser-shotgun",
		"name" : "LASER_SHOTGUN_ITM",
		"tier" : ToolTipGenerator.TIERS.CAVE,
		"scene" : "res://Items/Weapons/Scenes/LaserShotgun.tscn",
		"slotTexture" : "res://Items/Weapons/Sprites/LaserShotgun.png"
	},
	"sniper-rifle" : {
		"key" : "sniper-rifle",
		"name" : "SNIPER_RIFLE_ITM",
		"tier" : ToolTipGenerator.TIERS.CAVE,
		"scene" : "res://Items/Weapons/Scenes/SniperRifle.tscn",
		"slotTexture" : "res://Items/Weapons/Sprites/SniperRifle.png"
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
	"burst-shotgun" : {
		"key" : "burst-shotgun",
		"name" : "BURST_SHOTUN_ITM",
		"tier" : ToolTipGenerator.TIERS.DEEPLABS,
		"scene" : "res://Items/Weapons/Scenes/BurstShotgun.tscn",
		"slotTexture" : "res://Items/Weapons/Sprites/BurstShotgun.png"
	},
	"shield-launcher" : {
		"key" : "shield-launcher",
		"name" : "SHIELD_LAUNCHER_ITM",
		"tier" : ToolTipGenerator.TIERS.DEEPLABS,
		"scene" : "res://Items/Weapons/Scenes/ShieldLauncher.tscn",
		"slotTexture" : "res://Items/Weapons/Sprites/ShieldLauncher.png"
	},
	"splinter-gun" : {
		"key" : "splinter-gun",
		"name" : "SPLINTER_GUN_ITM",
		"tier" : ToolTipGenerator.TIERS.DEEPLABS,
		"scene" : "res://Items/Weapons/Scenes/SplinterGun.tscn",
		"slotTexture" : "res://Items/Weapons/Sprites/SplinterGun.png"
	},
	# FREEZERS ITEMS
	"j-laser" : {
		"key" : "j-laser",
		"name" : "J_LASER_ITM",
		"tier" : ToolTipGenerator.TIERS.FREEZERS,
		"scene" : "res://Items/Weapons/Scenes/JLaser.tscn",
		"slotTexture" : "res://Items/Weapons/Sprites/JLaser.png"
	},
	"soap-launcher" : {
		"key" : "soap-launcher",
		"name" : "SOAP_SLAPPER_ITM",
		"tier" : ToolTipGenerator.TIERS.FREEZERS,
		"scene" : "res://Items/Weapons/Scenes/SoapLauncher.tscn",
		"slotTexture" : "res://Items/Weapons/Sprites/SoapSlapper.png"
	},
	"fingergun" : {
		"key" : "fingergun",
		"name" : "FINGERGUN_ITM",
		"tier" : ToolTipGenerator.TIERS.FREEZERS,
		"scene" : "res://Items/Weapons/Scenes/FingerGun.tscn",
		"slotTexture" : "res://Items/Weapons/Sprites/FingerGun.png"
	},
	"bouncer" : {
		"key" : "bouncer",
		"name" : "BOUNCER_ITM",
		"tier" : ToolTipGenerator.TIERS.FREEZERS,
		"scene" : "res://Items/Weapons/Scenes/Bouncer.tscn",
		"slotTexture" : "res://Items/Weapons/Sprites/Bouncer.png"
	},
	"urchin-launcher" : {
		"key" : "urchin-launcher",
		"name" : "URCHIN_LAUNCHER_ITM",
		"tier" : ToolTipGenerator.TIERS.FREEZERS,
		"scene" : "res://Items/Weapons/Scenes/UrchinLauncher.tscn",
		"slotTexture" : "res://Items/Weapons/Sprites/UrchinLauncher.png"
	},
	"freezer" : {
		"key" : "freezer",
		"name" : "FREEZER_ITM",
		"tier" : ToolTipGenerator.TIERS.FREEZERS,
		"scene" : "res://Items/Weapons/Scenes/Freezer.tscn",
		"slotTexture" : "res://Items/Weapons/Sprites/Freezer.png"
	},
	# TOXIC CAVERNS ITEMS
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
	"minishotgun" : {
		"key" : "minishotgun",
		"name" : "MINISHOTGUN_ITM",
		"tier" : ToolTipGenerator.TIERS.TOXIC_CAVERNS,
		"scene" : "res://Items/Weapons/Scenes/Minishotgun.tscn",
		"slotTexture" : "res://Items/Weapons/Sprites/Minishotgun.png"
	},
	"toxic-grenade-launcher" : {
		"key" : "toxic-grenade-launcher",
		"name" : "TOXIC_GRENADE_LAUNCHER_ITM",
		"tier" : ToolTipGenerator.TIERS.TOXIC_CAVERNS,
		"scene" : "res://Items/Weapons/Scenes/ToxicGrenadeLauncher.tscn",
		"slotTexture" : "res://Items/Weapons/Sprites/ToxicGrenadeLauncher.png"
	},
	"fatnose-shotgun" : {
		"key" : "fatnose-shotgun",
		"name" : "FATNOSE_SHOTGUN_ITM",
		"tier" : ToolTipGenerator.TIERS.TOXIC_CAVERNS,
		"scene" : "res://Items/Weapons/Scenes/FatnoseShotgun.tscn",
		"slotTexture" : "res://Items/Weapons/Sprites/FatnoseShotgun.png"
	},
	# TECH LABS ITEMS
	"electroneer" : {
		"key" : "electroneer",
		"name" : "ELECTRONEER_ITM",
		"tier" : ToolTipGenerator.TIERS.TECH_LABS,
		"scene" : "res://Items/Weapons/Scenes/Electroneer.tscn",
		"slotTexture" : "res://Items/Weapons/Sprites/Electroneer.png"
	},
	"orblaster" : {
		"key" : "orblaster",
		"name" : "ORBLASTER_ITM",
		"tier" : ToolTipGenerator.TIERS.TECH_LABS,
		"scene" : "res://Items/Weapons/Scenes/Orblaster.tscn",
		"slotTexture" : "res://Items/Weapons/Sprites/Orblaster.png"
	},
	"charged-boomerang" : {
		"key" : "charged-boomerang",
		"name" : "CHARGED_BOOMERANG_ITM",
		"tier" : ToolTipGenerator.TIERS.TECH_LABS,
		"scene" : "res://Items/Weapons/Scenes/ChargedBoomerang.tscn",
		"slotTexture" : "res://Items/Weapons/Sprites/ChargedBoomerang.png"
	},
	"fist" : {
		"key" : "fist",
		"name" : "FIST_ITM",
		"tier" : ToolTipGenerator.TIERS.TECH_LABS,
		"scene" : "res://Items/Weapons/Scenes/Fist.tscn",
		"slotTexture" : "res://Entities/Player/Assets/Hand.png"
	},
}


const PASSIVES = {
	"LABS_TTL" : [
		"res://Items/Passives/AmmoUp/AmmoUp.tres",
		"res://Items/Passives/SpeedUp/SpeedUp.tres",
		"res://Items/Passives/HPUp/HPUp.tres",
		"res://Items/Passives/ExtraTrigger/ExtraTrigger.tres",
		"res://Items/Passives/Box/Box.tres",
	],
	"BACKEND_TTL" : [
		"LABS_TTL",
		"res://Items/Passives/BlockGame/BlockGame.tres",
		"res://Items/Passives/BounceGoo/BounceGoo.tres",
		"res://Items/Passives/FloatingRock/FloatingRock.tres",
		"res://Items/Passives/ToiletPaper/ToiletPaper.tres",
	],
	"DEEP_LABS_TTL" : [
		"LABS_TTL",
		"BACKEND_TTL",
		"res://Items/Passives/Pizza/Pizza.tres",
		"res://Items/Passives/Drone/Drone.tres",
		"res://Items/Passives/Butter/Butter.tres",
		"res://Items/Passives/Wings/Wings.tres",
	],
	"FREEZERS_TTL" : [
		"BACKEND_TTL",
		"DEEP_LABS_TTL",
		"res://Items/Passives/JarOfHearts/JarOfHearts.tres",
		"res://Items/Passives/LawnFlamingo/LawnFlamingo.tres",
		"res://Items/Passives/RemoteStapler/RemoteStapler.tres",
		"res://Items/Passives/TurtleShell/TurtleShell.tres",
	],
	"TOXIC_CAVERNS_TTL" : [
		"DEEP_LABS_TTL",
		"FREEZERS_TTL",
		"res://Items/Passives/JoeAmoeba/JoeAmoeba.tres",
		"res://Items/Passives/Coin/Coin.tres",
	]
}


static func get_passive_list(biome: String=PASSIVES.keys().back(), recurse:=true) -> Array:
	var list: Array = PASSIVES[biome]
	var keys := PASSIVES.keys()
	if recurse:
		for i in list.size():
			if list[i] in keys:
				list += get_passive_list(list[i], false)
	for i in keys:
		list.erase(i)
	return list


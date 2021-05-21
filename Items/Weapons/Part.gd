extends Node2D

export var isBody = false
export(int, "Common", "Uncommon", "Rare", "Unique") var rarity
#export(Array, PackedScene) var whitelistedParts
export(Array, StreamTexture) var whitelistedBulletSprites
export(int, "Pistol", "Shotgun", "Rifle", "Sniper", "Explosive") var gunType
export var bulletSpawnDist : int
export var fullyAutomatic = false
export var peircing = false
export var look : int
export var damage : float
export var recoil : float
export var cooldown : float
export var multishot : int
export var projSpeed : float
export var projScale : float
export var spread : float
export var accuracy : float
export var kickUp : float
export var isHitscan = false


func get_stats() -> Dictionary:
	var stats = {
		"isBody"       : isBody,
		"look"           : look,
		"damage"       : damage,
		"peircing"   : peircing,
		"recoil"       : recoil,
		"cooldown"   : cooldown,
		"multishot" : multishot,
		"projSpeed" : projSpeed,
		"projScale" : projScale,
		"spread"       : spread,
		"accuracy"   : accuracy,
		"kickUp"       : kickUp,
		"isHitscan" : isHitscan,
	}
	
	if isBody:
		stats.fullyAutomatic = fullyAutomatic
		stats.gunType = gunType
		stats.whitelistedBulletSprites = whitelistedBulletSprites
		stats.bulletSpawnDist = bulletSpawnDist
	
	return stats

extends Resource
class_name WeaponConstructor

enum {
	COMMON,
	UNCOMMON,
	RARE
}

var tierChances = [.10, .20, .70]


func generate_weapon(_seed:int=randi()):
	seed(_seed)

	var selectedParts = {
		"body" : null,
		"handle" : null,
		"barrel" : null,
		"sight" : null
	}

	parts.shuffle()
	var selectedWeapon = parts.front()

	selectedParts = select_parts(selectedWeapon)

	# Creating the body
	var constructedWeapon = selectedParts.body.instance()
	var handle = selectedParts.handle.instance()
	constructedWeapon.get_node("Handle").add_child(handle)
	var barrel = selectedParts.barrel.instance()
	constructedWeapon.get_node("Barrel").add_child(barrel)
	print(constructedWeapon.get_node("Handle").position)
	var data = generate_stats(selectedParts, constructedWeapon)

	data.scene = constructedWeapon
	data.isTwoHanded = handle.isTwoHanded
	data.seed = _seed

	return data


func generate_stats(selectedParts:Dictionary, body:Node2D):
	var keys = selectedParts.keys()
	keys.erase("body")

	var data = {}

	data.damage = body.damage
	data.accuracy = body.accuracy
	data.cooldown = body.cooldown
	data.multishot = body.multishot
	data.spread = body.spread
	data.projSpeed = body.projSpeed
	data.projScale = body.projScale
	data.projLifetime = body.projLifetime
	data.peircing = body.peircing
	data.recoil = body.recoil
	data.look = body.look
	data.cost = body.cost
	data.maxHoldShots = body.maxHoldShots
	data.customBullet = body.customBullet

	data.bulletSprite = body.bulletSprite
	data.kickUp = body.kickUp
	data.bulletSpawnDist = body.bulletSpawnDist

	data.ssFreq = body.ssFreq
	data.ssStrength = body.ssStrength

	# Modifying the stats
	for p in keys:
		var part:Node = selectedParts[p].instance()
		# Applying the part mods
		for i in data.keys():
			if data[i] is float:
				data[i] += data[i]*part.get(i)

	var oldChances = tierChances.duplicate()
	tierChances = [.60, .30, .10]
	data.tier = select_tier()
	tierChances = oldChances

	return data


func select_parts(selectedWeapon):
	var weaponPath = "res://Items/Weapons/Resources/%s/" % selectedWeapon
	var weaponParts = {}
	# Body
	weaponParts.body = load(weaponPath+"Body%s.tscn" % select_tier())
	# Handle
	weaponParts.handle = load(weaponPath+"Handle%s.tscn" % select_tier())
	# Barrel
	weaponParts.barrel = load(weaponPath+"Barrel%s.tscn" % select_tier())
	# Sight
	# TODO: Add sights
	return weaponParts


func select_tier():
	var roll = rand_range(1-tierChances[0], 1)
	# Looping through backwards and checking if
	# it rolled a good number for a tier.

	# `i` is the tier, and `chance` is the chance
	# of rolling for that tier.
	for i in tierChances.size():
		var chance = tierChances[(tierChances.size()-1)-i]
		if roll >= 1-chance:
			return i


var parts = [
	'Pistol'
]

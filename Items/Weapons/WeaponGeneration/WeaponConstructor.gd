extends Reference
class_name WeaponConstructor

enum {
	COMMON,
	UNCOMMON,
	RARE
}

var tierChances = [.38, .36, .26]

var perks = [
	# Common
	[null, preload("res://Items/Weapons/Perks/BulletBounce.gd")],
	# Uncommon
	[null],
	# Rare
	[null]
]

var prefixes = [
	{
		"path": "res://Items/Weapons/Resources/0Prefixes/EnhancedPrefix.tscn",
		"rarity" : .2
	},
	{
		"path": "res://Items/Weapons/Resources/0Prefixes/BrokenPrefix.tscn",
		"rarity" : .3
	}
]

var selectedPrefixName: String

func generate_weapon(_seed:int=randi(), _selectedType:String=""):
	seed(_seed)

	var selectedParts = {
		"body" : null,
		"handle" : null,
		"barrel" : null,
		"sight" : null,
		"prefix" : null
	}

	parts.shuffle()
	var selectedWeapon = parts.front()
	if _selectedType != "": 
		selectedWeapon = _selectedType

	selectedParts = select_parts(selectedWeapon)

	# Creating the body
	var constructedWeapon = selectedParts.body.instance()
	var handle = selectedParts.handle.instance()
	constructedWeapon.get_node("Handle").add_child(handle)
	var barrel = selectedParts.barrel.instance()
	constructedWeapon.get_node("Barrel").add_child(barrel)
	if selectedParts.has("sight"):
		var sight = selectedParts.sight.instance()
		constructedWeapon.get_node("Sight").add_child(sight)
	
	# Generating stats
	var data = generate_stats(selectedParts, constructedWeapon)
	
	if rand_range(0, 1) < .75:
		var perkTier = select_tier()
		data.perk = perks[perkTier][rand_range(0, perks[perkTier].size())]
	else:
		data.perk = null
	
	var name: String = selectedWeapon
	if data.perk:
		var perk = data.perk.new()
		name = perk.PERK_ADJ+" "+name
		perk.free()
	if selectedParts.has("prefix"):
		var prefix = selectedParts.prefix.instance()
		name = prefix.name+" "+name
		prefix.queue_free()
	
	data.prefixName = selectedPrefixName
	data.name = name
	data.scene = constructedWeapon
	data.ssStrength = clamp(data.ssStrength, 0, 16)
	data.cost = generate_cost(data)
	data.isTwoHanded = handle.isTwoHanded
	data.bulletSpawnDist = barrel.get_node("Sprite").texture.get_width()/2
	data.shellSprite = constructedWeapon.shellSprite
	
	var textureWidth = constructedWeapon.get_node("Sprite").texture.get_width()
	data.holdDist = (textureWidth*.3)-(int(data.isTwoHanded)*(textureWidth*.1))
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
	data.magazineSize = body.magazineSize
	data.reloadSpeed = body.reloadSpeed

	data.bulletSprite = body.bulletSprite
	data.kickUp = body.kickUp

	data.ssFreq = body.ssFreq
	data.ssStrength = body.ssStrength

	# Modifying the stats
	for p in keys:
		var part:Node = selectedParts[p].instance()
		# Applying the part mods
		for i in data.keys():
			if data[i] is float:
				data[i] += data[i]*part.get(i)
		part.queue_free()

	var oldChances = tierChances.duplicate()
	tierChances = [.60, .30, .10]
	data.tier = select_tier()
	tierChances = oldChances

	return data


func select_parts(selectedWeapon):
	var weaponPath = "res://Items/Weapons/Resources/%s/" % selectedWeapon
	var sightPath = "res://Items/Weapons/Resources/GlobalParts/Sight%s.tscn"
	var weaponParts = {}
	# Body
	weaponParts.body = load(weaponPath+"Body%s.tscn" % select_tier())
	# Handle
	weaponParts.handle = load(weaponPath+"Handle%s.tscn" % select_tier())
	# Barrel
	weaponParts.barrel = load(weaponPath+"Barrel%s.tscn" % select_tier())
	# Sight
	if rand_range(0, 1) < .5:
		weaponParts.sight = load(sightPath % round(rand_range(0, 2)))
	if rand_range(0, 1) < .8:
		prefixes.shuffle()
		var prefix = prefixes.pop_front()
		while true:
			if rand_range(0, 1) < prefix.rarity:
				weaponParts.prefix = load(prefix.path)
				var node = weaponParts.prefix.instance()
				selectedPrefixName = node.name
				node.queue_free()
				break
			if prefixes.size() == 0:
				break
			prefix = prefixes.pop_front()
		
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


func generate_cost(item:Dictionary):
	var cost := 50
	cost += item.damage    * 1.3
	cost += item.cooldown  *   3
	cost += item.multishot *   5
	cost -= item.accuracy  *  .5
	return cost


var parts = [
	'Pistol',
	'Shotgun',
	'AssaultRifle'
]

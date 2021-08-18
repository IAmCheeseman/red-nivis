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

	var data = generate_stats(selectedParts, constructedWeapon)

	data.scene = constructedWeapon
	data.isTwoHanded = handle.isTwoHanded
	data.seed = _seed
	data.sprite = generate_sprite(selectedParts)

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


func generate_sprite(selectedParts:Dictionary):
	var sprite:Image = Image.new()
	sprite.create(64, 64, true, Image.FORMAT_RGBA8)
	var offset = sprite.get_size()/2
	var body = selectedParts.body.instance()

	# Pasting in the body
	var spriteNode = body.get_node("Sprite")
	var bodyData:Image = spriteNode.texture.get_data()
	bodyData.convert(sprite.get_format())
	var usedRect = body.get_node("Sprite").region_rect

	sprite.lock()

	sprite.blend_rect(bodyData, usedRect, offset)

	var handle = selectedParts.handle.instance()
	sprite = copy_part_to_img(
		sprite,
		handle,
		offset+handle.get_node("Sprite").position+body.get_node("Handle").position
	)

	var barrel = selectedParts.barrel.instance()
	sprite = copy_part_to_img(
		sprite,
		barrel,
		offset+barrel.get_node("Sprite").position+body.get_node("Barrel").position
	)

	sprite.unlock()

	sprite.save_png("user://weapon.png")

	var texture = ImageTexture.new()
	var rect = sprite.get_used_rect()
	rect.position -= Vector2.ONE
	rect.end += Vector2.ONE
	texture.create_from_image(sprite.get_rect(rect))

	return texture


func copy_part_to_img(img:Image, part, offset):
	var usedRect = part.get_node("Sprite").region_rect
	var partData = part.get_node("Sprite").texture.get_data()
	partData.convert(img.get_format())
	print("%s: %s" % [part.name, offset])
	img.blend_rect(
		partData,
		usedRect,
		offset
	)

	return img


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

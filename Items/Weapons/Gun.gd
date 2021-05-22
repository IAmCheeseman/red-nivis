extends Node2D

onready var pickUpArea = $PickUpArea
onready var gunLogic = $GunLogic
onready var pivot = $Pivot
onready var tooltips = $TooltipHolder/GunTooltips/Tooltips
onready var tooltipsAnim = $TooltipHolder/GunTooltips/AnimationPlayer
onready var tooltipHolder = $TooltipHolder
onready var shootSound = $ShootSound
var body

var gunTypes = [" Pistol", " Shotgun", " Rifle", " Sniper", " Explosive"]

var rarities = [
	80.0,
	55.0,
	35.0,
	15.0
]

var isPickedUp = false
var canShoot = true
var standingOver = false
var gunSeed
var player

var grip

export(Array, String) var bodies

var stats = {
		"isBody" : true,
		"look" : 0,
		"damage" : 0,
		"peircing" : false,
		"recoil" : 1,
		"cooldown" : .2,
		"multishot" : 1,
		"projSpeed" : 430,
		"projScale" : 1,
		"spread" : 0,
		"accuracy" : 12,
		"kickUp" : 25,
		"isHitscan" : false
	}


func _ready():
	if !isPickedUp:
		# Setting up
		randomize()
		gunLogic.set_physics_process(false)
		rotation_degrees = rand_range(0, 360)


		# Selecting the gun body

		bodies.shuffle()
		var newBody = load(bodies[0]).instance()
		var loops = 0
		while rand_range(0, 100) > rarities[newBody.rarity] and loops < 50:
			bodies.shuffle()
			newBody = load(bodies[0]).instance()
			loops += 1

		pivot.add_child(newBody)
		body = newBody


		# Setting the gun stats
		stats = body.get_stats()
		stats.body = bodies[0]


		# Adding Parts

		# Adding the over barrel attachment, such as a scope
		var useOverBarrelAttach = rand_range(0, 2)
		if useOverBarrelAttach <= 1:
			var overBarrelPosition = body.get_node("Sight")
			add_part_with_stats(overBarrelPosition, "sight")

		var useGrip = rand_range(0, 2)
		if useGrip <= 1:
			var gripPosition = body.get_node("Grip")
			add_part_with_stats(gripPosition, "grip")

		var useSlider = rand_range(0, 2)
		if useSlider <= 1:
			var slider = body.get_node("ReloadSlider")
			add_part_with_stats(slider, "slider")

		var barrel = body.get_node("Barrel")
		add_part_with_stats(barrel, "barrel")


		# Adjusting stats
		stats.damage += stats.projSpeed/80*stats.projScale/5
		stats.accuracy -= stats.projSpeed/90
		stats.spread += (stats.multishot/5)*int(stats.multishot > 1)
		stats.look -= 8*int(stats.multishot>1)
		stats.look += 8*int( (stats.peircing and stats.projSpeed>430) or stats.isHitscan)
		stats.cooldown = clamp(stats.cooldown, .1, INF)
		# DON'T USE MULTISHOT IN HITSCAN SCRIPT

		set_gun_logic()

	else:
		pickUpArea.queue_free()
		tooltipHolder.queue_free()

		var newBody = load(stats.body).instance()
		pivot.add_child(newBody)

		var overBarrelPosition = newBody.get_node("Sight")
# warning-ignore:shadowed_variable
		var grip = newBody.get_node("Grip")
		var barrel = newBody.get_node("Barrel")
		var slider = newBody.get_node("ReloadSlider")
		add_part(overBarrelPosition, "sight")
		add_part(grip, "grip")
		add_part(barrel, "barrel")
		add_part(slider, "slider")

		shootSound.audio = stats.shootSound

		set_active()
	tooltipHolder.global_rotation_degrees = 0
	setTooltips()


func setTooltips():
	var description = ""
	description += gunTypes[stats.gunType]+"\n"
	description += " Damage: %s\n" % stepify(stats.damage, .1)
	description += " Cooldown: %s\n" % stepify(stats.cooldown, .1)
	description += " Accuracy: %s" % stepify(stats.accuracy, .1) if stats.accuracy > 0 else " Accuracy: %s" % -stepify(stats.accuracy, .1)

	if stats.multishot > 1:
		description += "\n Multishot: %s\n" % stats.multishot
		description += " Spread: %s" % stepify(stats.spread, .1)

	tooltips.text = description


func add_part(partPos : Position2D, partName : String):
	if stats.has(partName):
		var newPart = stats[partName].instance()
		partPos.add_child(newPart)


func add_part_with_stats(partPos : Position2D, statsName : String):
	var whitelist = partPos.whitelistedParts
	if whitelist.size() > 0:
		var newPart = get_part(whitelist)

		var partStats = newPart.get_stats()

		for stat in partStats.keys():
			if stats[stat] is int:
				stats[stat] += partStats[stat]
				stats[stat] = clamp(stats[stat], 0, INF)
				stats[statsName] = whitelist[0]
				continue

			elif stats[stat] is float:
				var addAmount
				if partStats[stat] < 0:
					addAmount = -GameManager.percentage_from(-partStats[stat], stats[stat])
				else:
					addAmount = GameManager.percentage_from(partStats[stat], stats[stat])
				stats[stat] += addAmount
				stats[stat] = clamp(stats[stat], 0, INF)
		stats[statsName] = whitelist[0]

		partPos.add_child(newPart)


func get_part(whitelist : Array):
	var newPart = shuffle_pop(whitelist)
	var loops = 0
	var maxLoops = 50
	while rand_range(0, 100) > rarities[newPart.rarity] and loops < maxLoops:
		whitelist.shuffle()
		newPart = shuffle_pop(whitelist)
		loops += 1
	return newPart


func shuffle_pop(whitelist : Array):
	whitelist.shuffle()
	return whitelist.duplicate().pop_front().instance()


func set_active():
	set_gun_logic()
	gunLogic.barrelEnd = $Pivot/BarrelEnd
	gunLogic.pivot = $Pivot
	gunLogic.cooldownTimer = $Cooldown
	gunLogic.shootSound = $ShootSound
	gunLogic.set_physics_process(true)

	var gripP = $Pivot/GunBody/Grip
	if gripP.get_child_count() == 1:
		grip = gripP.get_child(0)


func set_logic(on : bool):
	set_physics_process(on)
	gunLogic.set_physics_process(on)
	if !grip:
		return
	if grip.get_child_count() == 2:
		grip.get_child(1).set_laser(on)


func _on_PickUpArea_area_entered(area):
	if area.is_in_group("player"):
		standingOver = true
		tooltipsAnim.play("Appear")
		player = area.get_parent()


func _on_PickUpArea_area_exited(area):
	if area.is_in_group("player"):
		standingOver = false
		tooltipsAnim.play("Disappear")


func _input(event):
	if event.is_action_pressed("interact") and standingOver:
		equipSelf()


func equipSelf():
	isPickedUp = true
	GameManager.heldItem = self.duplicate()
	set_active()
	pickUpArea.call_deferred("queue_free")
	player.add_item(self)


func set_gun_logic():
	if stats.isHitscan:
		pass
	else:
		gunLogic.set_script(load("res://Items/Weapons/ProjectileBasedGun.gd"))
	gunLogic.stats = stats
	gunLogic.body = body


func _on_Cooldown_timeout():
	canShoot = true


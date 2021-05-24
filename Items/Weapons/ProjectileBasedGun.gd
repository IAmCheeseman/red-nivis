extends Node2D

onready var pivot = get_parent().get_node("Pivot")
onready var barrelEnd = get_parent().get_node("Pivot/BarrelEnd")
onready var cooldownTimer = get_parent().get_node("Cooldown")
var shootSound : SoundManager
var body
var stats
var rotVel = 0
var lastFrameRot = 0

var shellPositions = [
	Rect2(Vector2(0, 0), Vector2(3, 5)),
	Rect2(Vector2(3, 0), Vector2(4, 6)),
	Rect2(Vector2(7, 0), Vector2(3, 5)),
	Rect2(Vector2(7, 0), Vector2(3, 5)),
	Rect2(Vector2(3, 0), Vector2(4, 6)),
]

var bullet = preload("res://Items/Weapons/Bullet/Bullet.tscn")


func _physics_process(delta):
	body = get_parent().get_node("Pivot/GunBody")

	# Flipping the gun based on rotation
	var local = barrelEnd.global_position-global_position
	if local.x < 0:
		body.scale.y = -1
	else:
		body.scale.y = 1
	# Showing the gun behind the parent based on rotation
	get_parent().get_parent().show_behind_parent = local.y < 0

	# Setting rotation
	var pastRot = body.global_rotation
	pivot.look_at(get_global_mouse_position())
	var targetRot = pivot.global_rotation

	body.global_rotation = lerp_angle(pastRot, targetRot, 3.2*delta)

	# Settling the rotation of the gun down after it's been kicked up
	body.rotation = lerp_angle(body.rotation, 0, 4*delta)

	# Shooting
	if stats.fullyAutomatic:
		if Input.is_action_pressed("use_item") and get_parent().canShoot:
			shoot()
	else:
		if Input.is_action_just_pressed("use_item") and get_parent().canShoot:
			shoot()
	lastFrameRot = pivot.rotation_degrees


func shoot():
	randomize()

	for i in stats.multishot:

		# Getting the direction that the bullet needs to go in.
		var dir = global_position.direction_to(get_global_mouse_position())
		var spread = deg2rad(stats.spread*i-(stats.spread*(stats.multishot-1)/2))
		var accuracy = deg2rad(rand_range(-stats.accuracy, stats.accuracy))
		dir = dir.rotated(spread+accuracy)

		# Creating the bullet.
		var newBullet = bullet.instance()
		newBullet.direction = dir.normalized()
		newBullet.speed = stats.projSpeed+rand_range(-30, 30)
		newBullet.scale = Vector2.ONE*stats.projScale
		newBullet.peircing = stats.peircing
		newBullet.global_position = global_position+dir*stats.bulletSpawnDist
		# Adding it to the tree
		get_tree().root.get_child(3).add_child(newBullet)
		newBullet.hitbox.damage = stats.damage
		newBullet.set_texture(stats.bulletSprite, stats.lightTexture)

		# Rotating the gun for juice
		body.rotation_degrees = -stats.kickUp*3.2

		# Removing the ability to shoot for X amount of time
		get_parent().canShoot = false
		cooldownTimer.start(stats.cooldown)

	# Screenshake

	# Getting the parameters
	var strength = 8*GameManager.percentage_from(10, stats.damage)
	strength *= stats.cooldown+.5
	var freq = stats.damage/1000
	freq *= stats.cooldown+.5
	freq = clamp(freq, .05, .1)

	var direction = -global_position.direction_to(get_global_mouse_position())

	# Shaking the camera
	GameManager.emit_signal("screenshake", 0, strength*2, freq, freq, strength/3, direction)

	# Playing a sound for feedback
	get_parent().get_node("ShootSound").play()

	# Creating a bullet shell
	var shell = load("res://Items/Weapons/Bullet/Shell.tscn").instance()
	shell.global_position = global_position
	shell.dist = rand_range(16, 32)
	shell.shellRect = shellPositions[stats.gunType]
	get_tree().root.get_child(3).add_child(shell)
	shell.start(-global_position.direction_to(get_global_mouse_position()).rotated(deg2rad(rand_range(-15, 15) ) ) )

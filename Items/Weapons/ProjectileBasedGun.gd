extends Node2D

onready var pivot = get_parent().get_node("Pivot")
onready var barrelEnd = get_parent().get_node("Pivot/BarrelEnd")
onready var cooldownTimer = get_parent().get_node("Cooldown")
onready var gunSprite = get_parent().get_node("Pivot/GunSprite")
onready var gun = get_parent()
var shootSound : SoundManager
var rotVel = 0
var lastFrameRot = 0

enum {CALLED_ON_SHOOT, CALLED_ON_HIT}

var shellPositions = [
	Rect2(Vector2(0, 0), Vector2(3, 5)),
	Rect2(Vector2(3, 0), Vector2(4, 6)),
	Rect2(Vector2(7, 0), Vector2(3, 5)),
	Rect2(Vector2(7, 0), Vector2(3, 5)),
	Rect2(Vector2(3, 0), Vector2(4, 6)),
]

var bullet = preload("res://Items/Weapons/Bullet/Bullet.tscn")


func _physics_process(delta):
	# Flipping the gun based on rotation
	var local = barrelEnd.global_position-global_position
	if local.x < 0:
		gunSprite.scale.y = -1
	else:
		gunSprite.scale.y = 1
	# Showing the gun behind the parent based on rotation
	get_parent().get_parent().show_behind_parent = local.y < 0

	# Setting rotation
	var pastRot = gunSprite.global_rotation
	pivot.look_at(get_global_mouse_position())
	var targetRot = pivot.global_rotation

	gunSprite.global_rotation = lerp_angle(pastRot, targetRot, 3.2*delta)

	# Settling the rotation of the gun down after it's been kicked up
	gunSprite.rotation = lerp_angle(gunSprite.rotation, 0, 4*delta)
	pivot.scale = pivot.scale.move_toward(Vector2.ONE, 12*delta)

	# Shooting
	if Input.is_action_pressed("use_item") and get_parent().canShoot:
		shoot()
	lastFrameRot = pivot.rotation_degrees


func shoot():
	randomize()

	for i in gun.multishot:

		# Getting the direction that the bullet needs to go in.
		var dir = global_position.direction_to(get_global_mouse_position())
		var spread = deg2rad(gun.spread*i-(gun.spread*(gun.multishot-1)/2))
		var accuracy = deg2rad(rand_range(-gun.accuracy, gun.accuracy))
		dir = dir.rotated(spread+accuracy)

		# Creating the bullet.
		var newBullet = bullet.instance()
		newBullet.direction = dir.normalized()
		newBullet.speed = gun.projSpeed+rand_range(-50, 60)
		newBullet.scale = Vector2.ONE*gun.projScale
		newBullet.peircing = gun.peircing
		newBullet.global_position = global_position+dir*gun.bulletSpawnDist
		# Adding it to the tree
		get_tree().root.get_child(3).add_child(newBullet)
		newBullet.hitbox.damage = gun.damage
		newBullet.set_texture(gun.bulletSprite, gun.lightTexture)
		if gun.has("prefix"):
			newBullet.prefix = gun.prefix
		newBullet.gun = gun

		# Rotating the gun for juice
		gunSprite.rotation_degrees = gun.kickUp*2.2 if gunSprite.scale.y == -1 else -gun.kickUp*2.2
		var shotScale = rand_range(1.2, 1.9)
		pivot.scale = Vector2(shotScale, shotScale )

		# Removing the ability to shoot for X amount of time
		get_parent().canShoot = false
		cooldownTimer.start(gun.cooldown)

	# Creating the prefix effect
	#if gun.has("prefix"):
	#	if gun.prefix.callMethod == 0:
	#		var statEffect = load(gun.prefix.effect).instance()
	#		add_child(statEffect)

	# Screenshake

	# Getting the parameters
	var strength = 8*GameManager.percentage_from(10, gun.damage)
	strength *= gun.cooldown+.5
	var freq = gun.damage/1000
	freq *= gun.cooldown+.5
	freq = clamp(freq, .08, .2)

	var direction = -global_position.direction_to(get_global_mouse_position())

	# Shaking the camera
	GameManager.emit_signal("screenshake", 0, strength*2, freq, freq, strength/3, direction)

	# Playing a sound for feedback
	get_parent().get_node("ShootSound").play()

	get_parent().emit_signal("onShoot", global_position.direction_to(get_global_mouse_position()), gun.recoil)

	# Creating a bullet shell
	var shell = load("res://Items/Weapons/Bullet/Shell.tscn").instance()
	shell.global_position = global_position
	shell.dist = rand_range(16, 32)
	shell.shellRect = shellPositions[gun.gunType]
	get_tree().root.get_child(3).add_child(shell)
	shell.start(-global_position.direction_to(get_global_mouse_position()).rotated(deg2rad(rand_range(-15, 15) ) ) )

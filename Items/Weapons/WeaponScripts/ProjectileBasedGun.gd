extends "res://Items/Weapons/WeaponScripts/GunLogic.gd"

func shoot():
	randomize()

	holdShots += 1
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
		newBullet.lifetime = gun.projLifetime
		newBullet.global_position = global_position+dir*gun.bulletSpawnDist
		# Adding it to the tree
		GameManager.spawnManager.add_bullet(newBullet)
		newBullet.hitbox.damage = gun.damage

		newBullet.set_texture(gun.bulletSprite)

		# Rotating the gun for juice
		gunSprite.rotation_degrees = gun.kickUp*2.2 if gunSprite.scale.y == -1 else -gun.kickUp*2.2
		pivot.scale = Vector2(rand_range(1.2, 1.4), rand_range(1.2, 1.4))

		# Removing the ability to shoot for X amount of time
		get_parent().canShoot = false
		cooldownTimer.start(gun.cooldown)
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

	get_parent().emit_signal("onShoot", global_position.direction_to(get_global_mouse_position()), gun.recoil, gun.cost)

	# Creating a bullet shell
	var newShell = shell.instance()
	newShell.global_position = global_position
	newShell.dist = rand_range(16, 32)
	newShell.shellRect = shellPositions[gun.gunType]
	GameManager.spawnManager.add_bullet(shell)
	newShell.start(-global_position.direction_to(get_global_mouse_position()).rotated(deg2rad(rand_range(-15, 15) ) ) )


func _input(event):
	if Input.is_action_just_released("use_item"):
		holdShots = 0






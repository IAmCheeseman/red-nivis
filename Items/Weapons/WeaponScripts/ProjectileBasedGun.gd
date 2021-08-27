extends "res://Items/Weapons/WeaponScripts/GunLogic.gd"

func shoot():
	randomize()

	holdShots += 1
	for i in gun.stats.multishot:
		# Getting the direction that the bullet needs to go in.
		var dir = global_position.direction_to(get_global_mouse_position())
		var spread = deg2rad(gun.stats.spread*i-(gun.stats.spread*(gun.stats.multishot-1)*.5))#*int(gun.stats.spread != 0)
		var accuracy = deg2rad(rand_range(-gun.stats.accuracy, gun.stats.accuracy))
		dir = dir.rotated(spread+accuracy)

		# Creating the bullet.
		var newBullet = bullet.instance() if !gun.stats.customBullet else gun.stats.customBullet.instance()
		newBullet.direction = dir.normalized()
		newBullet.speed = gun.stats.projSpeed+rand_range(-50, 60)
		newBullet.scale = Vector2.ONE*gun.stats.projScale
		newBullet.peircing = gun.stats.peircing
		newBullet.lifetime = gun.stats.projLifetime
		newBullet.global_position = global_position+dir*gun.stats.bulletSpawnDist
		# Adding it to the tree
		GameManager.spawnManager.spawn_object(newBullet)
		if newBullet.has_node("Hitbox"): newBullet.hitbox.damage = gun.stats.damage
		else: newBullet.damage = gun.stats.damage

		if newBullet.has_meta("set_texture"): newBullet.set_texture(gun.bulletSprite)

		# Rotating the gun for juice
		gun.visuals.rotation_degrees = gun.stats.kickUp*2.2 if gun.visuals.scale.y == -1 else -gun.stats.kickUp*2.2
		pivot.scale = Vector2(rand_range(1.2, 1.4), rand_range(1.2, 1.4))

		# Removing the ability to shoot for X amount of time
		get_parent().canShoot = false
		cooldownTimer.start(gun.stats.cooldown)
	# Screenshake

	# Getting the parameters

	var direction = -global_position.direction_to(get_global_mouse_position())

	# Shaking the camera
	GameManager.emit_signal("screenshake",
	0, gun.stats.ssStrength,
	gun.stats.ssFreq, gun.stats.ssFreq, direction)
	Cursor.get_node("Sprite").rotate_cursor(gun.stats.cooldown)

	# Playing a sound for feedback
	gun.get_node("ShootSound").play()

#	gun.player.vel += -global_position.direction_to(get_global_mouse_position())*gun.stats.recoil
	playerData.ammo -= gun.stats.cost



func _input(_event):
	if Input.is_action_just_released("use_item"):
		holdShots = 0






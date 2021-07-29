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
		var newBullet = bullet.instance() if !gun.customBullet else gun.customBullet.instance()
		newBullet.direction = dir.normalized()
		newBullet.speed = gun.projSpeed+rand_range(-50, 60)
		newBullet.scale = Vector2.ONE*gun.projScale
		newBullet.peircing = gun.peircing
		newBullet.lifetime = gun.projLifetime
		newBullet.global_position = global_position+dir*gun.bulletSpawnDist
		# Adding it to the tree
		GameManager.spawnManager.spawn_object(newBullet)
		if newBullet.has_node("Hitbox"): newBullet.hitbox.damage = gun.damage
		else: newBullet.damage = gun.damage

		if newBullet.has_meta("set_texture"): newBullet.set_texture(gun.bulletSprite)

		# Rotating the gun for juice
		gunSprite.rotation_degrees = gun.kickUp*2.2 if gunSprite.scale.y == -1 else -gun.kickUp*2.2
		pivot.scale = Vector2(rand_range(1.2, 1.4), rand_range(1.2, 1.4))

		# Removing the ability to shoot for X amount of time
		get_parent().canShoot = false
		cooldownTimer.start(gun.cooldown)
	# Screenshake

	# Getting the parameters

	var direction = -global_position.direction_to(get_global_mouse_position())

	# Shaking the camera
	GameManager.emit_signal("screenshake", 0, gun.ssStrength, gun.ssFreq, gun.ssFreq, gun.ssStrength/3, direction)

	# Playing a sound for feedback
	gun.get_node("ShootSound").play()

	gun.player.vel += -global_position.direction_to(get_global_mouse_position())*gun.recoil
	playerData.ammo -= gun.cost



func _input(_event):
	if Input.is_action_just_released("use_item"):
		holdShots = 0






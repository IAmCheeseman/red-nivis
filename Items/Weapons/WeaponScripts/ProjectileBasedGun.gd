extends "res://Items/Weapons/WeaponScripts/GunLogic.gd"

func shoot():
	randomize()

	var bullets = []
	holdShots += 1
	for i in gun.multishot:
		# Getting the direction that the bullet needs to go in.
		var dir = global_position.direction_to(Utils.get_global_mouse_position())
		# Controller aim assist
		if GameManager.usingController:
			dir = Utils.round_dir_to_target(gun, dir)

		var spread = deg2rad(gun.spread*i-(gun.spread*(gun.multishot-1)*.5))#*int(gun.spread != 0)
		var accuracy = deg2rad(rand_range(-gun.accuracy, gun.accuracy))
		dir = dir.rotated(spread+accuracy)

		# Creating the bullet.
		var newBullet = bullet.instance() if !gun.customBullet else gun.customBullet.instance()
		newBullet.direction = dir.normalized()
		newBullet.speed = gun.projSpeed+rand_range(gun.projSpeedRange.x, gun.projSpeedRange.y)
		newBullet.scale = Vector2.ONE*rand_range(gun.projScale.x, gun.projScale.y)
		newBullet.peircing = gun.peircing
		newBullet.lifetime = gun.projLifetime
		newBullet.global_position = global_position+dir*gun.bulletSpawnDist
		bullets.append(newBullet)
		newBullet.connect("hit_wall", self, "_on_bullet_hit_wall")
		newBullet.connect("hit_enemy", self, "_on_bullet_hit_enemy")
		
		# Adding it to the tree
		GameManager.spawnManager.add_child(newBullet)

		newBullet.damage = gun.damage * playerData.damageMod
		#yield(TempTimer.idle_frame(self), "timeout")
		if is_instance_valid(newBullet):
			if newBullet.get("hitbox"):
				newBullet.hitbox.effect = gun.perk
				newBullet.hitbox.kbStrengh = gun.projKB * playerData.kbMod

			if newBullet.has_meta("set_texture"): newBullet.set_texture(gun.bulletSprite)

		# Removing the ability to shoot for X amount of time
		get_parent().canShoot = false
		cooldownTimer.start(gun.cooldown*playerData.attackSpeed)
		gun.isReloading = false

		emit_signal("gun_shot", newBullet)

	# Rotating the gun for juice
	gun.visuals.rotation_degrees += gun.kickUp*2.2 if gun.visuals.scale.y == -1 else -gun.kickUp*2.2
	pivot.scale = Vector2(rand_range(1.2, 1.4), rand_range(1.2, 1.4))

	yield(TempTimer.idle_frame(self), "timeout")
	if gun.bulletSprite:
		for i in bullets:
			if is_instance_valid(i):
				if i.has_method("set_texture"): i.set_texture(gun.bulletSprite)
	# Screenshake

	# Getting the parameters
	var direction = -global_position.direction_to(
		Utils.get_global_mouse_position())

	# Shaking the camera
	GameManager.emit_signal("screenshake",
	0, gun.ssStrength,
	gun.ssFreq, gun.ssFreq, direction)
	
	gun.visuals.position.x = clamp(gun.gunPos.x - gun.ssStrength * 3, 5, INF)
	
	# Playing a sound for feedback
	gun.get_node("ShootSound").play()

	gun.player.playerObject.vel.x += (-get_local_mouse_position().normalized()*gun.recoil).x
	if playerData.ammo <= 0:
		cooldownTimer.stop()
		cooldownTimer.start(gun.reloadSpeed)
		cooldownTimer.set_meta("fromReload", true)
		gun.isReloading = true
		gun.visuals.rotation_degrees = gun.kickUp*5.2\
		if gun.visuals.scale.y == -1\
		else -gun.kickUp*5.2
		Cursor.get_node("Sprite").rotate_cursor(gun.reloadSpeed, 360)
	else:
		Cursor.get_node("Sprite").rotate_cursor(gun.cooldown, 90)
		cooldownTimer.set_meta("fromReload", false)


func _input(_event):
	if Input.is_action_just_released("use_item"):
		holdShots = 0






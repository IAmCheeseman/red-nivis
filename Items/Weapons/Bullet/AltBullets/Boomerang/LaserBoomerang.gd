extends "res://Items/Weapons/Bullet/AltBullets/Boomerang/Boomerang.gd"

onready var laserSFX = $LaserSFX

func add_laser() -> void:
	for i in 3:
		var newBullet = load("res://Items/Weapons/Bullet/AltBullets/LaserShot/Laser.tscn").instance()
		newBullet.direction = Vector2.RIGHT.rotated(rand_range(0, PI * 2))
		newBullet.damage = damage
		newBullet.global_position = global_position
		GameManager.spawnManager.spawn_object(newBullet)
	laserSFX.play()

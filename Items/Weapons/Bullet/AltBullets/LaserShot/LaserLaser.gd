extends "res://Items/Weapons/Bullet/AltBullets/LaserShot/Laser.gd"

var recursion := 1

func _ready():
	var _discard = connect("hit_wall", self, "_on_hit_wall")
	yield(TempTimer.idle_frame(self), "timeout")
	do_damage()
	
	yield(TempTimer.timer(self, .05), "timeout")
	
	if raycast.is_colliding() and recursion > 0:
		var bullets = 16
		for i in bullets:
			var newBullet = load("res://Items/Weapons/Bullet/AltBullets/LaserShot/LaserLaser.tscn").instance()
			newBullet.direction = Vector2.RIGHT.rotated(((PI * 2) / bullets) * i)
			newBullet.damage = damage
			newBullet.global_position = raycast.get_collision_point()
			newBullet.recursion = recursion - 1
			GameManager.spawnManager.spawn_object(newBullet)

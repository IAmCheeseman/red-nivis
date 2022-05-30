extends "res://Items/Weapons/Bullet/Bullet.gd"


func start() -> void:
	var _discard0 = connect("hit_enemy", self, "splinter")
	var _discard1 = connect("hit_wall", self, "splinter")


func splinter(_obj) -> void:
	var bulletCount := 16.0
		
	for i in bulletCount:
		var angle = deg2rad(360 * (float(i) / bulletCount))
		var dir = Vector2.RIGHT.rotated(angle)
		
		var newBullet = preload("res://Items/Weapons/Bullet/Bullet.tscn").instance()
		newBullet.global_position = global_position - (direction * 8)
		newBullet.direction = dir
		newBullet.speed = speed * 0.5
		newBullet.damage = damage * 0.333
		
		GameManager.spawnManager.add_child(newBullet)
		
		newBullet.set_texture(sprite.texture)

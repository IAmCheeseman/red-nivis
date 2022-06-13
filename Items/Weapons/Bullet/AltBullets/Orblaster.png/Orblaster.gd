extends "res://Items/Weapons/Bullet/Bullet.gd"

onready var laserSFX = $LaserSFX

var minSpeed = speed / 2.5
var scaleMod = scale.x
onready var ogScale = scale
var frict := 5


func _physics_process(delta):
	position += (direction * speed) * delta
	speed = lerp(speed, minSpeed, frict * delta)
	trail.hide()


func _exit_tree() -> void:
	remove_child(laserSFX)
	GameManager.spawnManager.spawn_object(laserSFX)
	laserSFX.play()
	
	var bullets = 16
	for i in bullets:
		var newBullet = load("res://Items/Weapons/Bullet/AltBullets/LaserShot/Laser.tscn").instance()
		newBullet.direction = Vector2.RIGHT.rotated(((PI * 2) / bullets) * i)
		newBullet.damage = damage
		newBullet.global_position = global_position
		GameManager.spawnManager.spawn_object(newBullet)

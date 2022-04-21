extends Node2D

onready var cooldown = $Cooldown

var bullet = preload("res://Entities/Enemies/EnemyBullet/HomingBullet.tscn")

var player: Node2D


func shoot() -> void:
	cooldown.start(cooldown.wait_time + rand_range(-.4, .4))
	if !player: return
	if global_position.distance_to(player.global_position) < 32:
		return
	if global_position.distance_to(player.global_position) > 160:
		return
	
	var rot = to_local(player.global_position + Vector2(0,-16*3)).angle()
	owner.vel = -Vector2.RIGHT.rotated(rot)*250
	
	
	var dir = Vector2.RIGHT.rotated(rot)
	var newBullet = bullet.instance()
	newBullet.direction = dir
	newBullet.speed = 100
	newBullet.damage = 1
	newBullet.global_position = global_position + (dir * 10)
	GameManager.spawnManager.spawn_object(newBullet)
	
	GameManager.add_attacking_enemy(self)
	randomize()


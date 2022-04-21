extends Node2D

onready var sprite = $Sprite
onready var PEWPEWTIERWOOO = $PewPewTiemr
onready var attackTimer = $AttackTimer
onready var barrelEnd = $BarrelEnd

var bullet = preload("res://Entities/Enemies/EnemyBullet/HomingBullet.tscn")

var player: Node2D


func _process(_delta: float) -> void:
	if !player: return
	look_at(player.global_position-Vector2(0, 8))
	sprite.flip_v = Vector2.RIGHT.rotated(rotation).x < 0
	sprite.material.set_shader_param("isOn", int(PEWPEWTIERWOOO.time_left < .6))
	sprite.scale.x = clamp(PEWPEWTIERWOOO.time_left / PEWPEWTIERWOOO.wait_time, .5, INF)
	sprite.scale.y = (1 - sprite.scale.x) + 1


func shoot() -> void:
	PEWPEWTIERWOOO.start(PEWPEWTIERWOOO.wait_time + rand_range(-.4, .4))
	if !player: return
	if global_position.distance_to(player.global_position) < 32:
		return
	if global_position.distance_to(player.global_position) > 160:
		return
	
	owner.vel = -Vector2.RIGHT.rotated(rotation)*250
	
	
	var dir = Vector2.RIGHT.rotated(rotation)
	var newBullet = bullet.instance()
	newBullet.direction = dir
	newBullet.speed = 300 * randf()
	newBullet.damage = 1
	newBullet.global_position = barrelEnd.global_position
	GameManager.spawnManager.spawn_object(newBullet)
	
	GameManager.add_attacking_enemy(self)
	randomize()
	attackTimer.start()


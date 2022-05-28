extends Node2D

onready var sprite = $Sprite
onready var cooldown = $Cooldown
onready var attackTimer = $AttackTimer
onready var barrelEnd = $BarrelEnd

var bullet = preload("res://Entities/Enemies/EnemyBullet/Aoe/AoeBullet.tscn")

var player: Node2D


func _process(_delta: float) -> void:
	if !player: return
	look_at(player.global_position-Vector2(0, 8))
	sprite.flip_v = Vector2.RIGHT.rotated(rotation).x < 0
	sprite.material.set_shader_param("isOn", int(cooldown.time_left < .6))
	sprite.scale.x = clamp(cooldown.time_left / cooldown.wait_time, .5, INF)
	sprite.scale.y = (1 - sprite.scale.x) + 1


func shoot() -> void:
	cooldown.start(cooldown.wait_time + rand_range(-.4, .4))
	if !player: return
	if GameManager.attacks_capped():
		attackTimer.start()
		return
	if global_position.distance_to(player.global_position) < 32:
		return
	if global_position.distance_to(player.global_position) > 160:
		return
	
	var spread = 45
	owner.vel = -Vector2.RIGHT.rotated(rotation)*250
	for i in 3:
		var angle = i-1
		angle *= spread
		var dir = Vector2.RIGHT.rotated(deg2rad(angle)+rotation)
		
		var newBullet = bullet.instance()
		newBullet.direction = dir
		newBullet.speed = 100
		newBullet.damage = 1
#		newBullet.peircing = true
		newBullet.global_position = barrelEnd.global_position
		GameManager.spawnManager.spawn_object(newBullet)
	
	GameManager.add_attacking_enemy(self)
	randomize()
	attackTimer.start()


func _on_attack_timer_timeout() -> void:
	if GameManager.enemy_is_attacking(self):
		GameManager.remove_attacking_enemy(self)


func _on_tree_exiting() -> void:
	if GameManager.enemy_is_attacking(self):
		GameManager.remove_attacking_enemy(self)

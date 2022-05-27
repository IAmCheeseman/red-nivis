extends Node2D

onready var sprite = $Sprite
onready var cooldown = $Cooldown
onready var attackTimer = $AttackTimer
onready var barrelEnd = $BarrelEnd

var bullet = preload("res://Entities/Enemies/EnemyBullet/Falling/FallingEnemyBullet.tscn")

var player: Node2D


func _process(_delta: float) -> void:
	if !player: return
#	var add = -32 if player.global_position.x < global_position.x else 32
#	look_at(Vector2(global_position.x + add, player.global_position.y - 64))
	
	look_at(player.global_position - Vector2(0, 128))
	
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
	
	owner.vel = -Vector2.RIGHT.rotated(rotation)*250
	
	
	var dir = Vector2.RIGHT.rotated(rotation)
	
	var newBullet = bullet.instance()
	newBullet.direction = dir
	newBullet.speed = 250
	newBullet.damage = 1
	newBullet.peircing = true
	newBullet.global_position = barrelEnd.global_position
	GameManager.spawnManager.spawn_object(newBullet)
	
	yield(TempTimer.idle_frame(self), "timeout")
	newBullet.set_texture(preload("res://Entities/Enemies/Slugs/GravityShooter/Slime.png"))
	
	GameManager.add_attacking_enemy(self)
	randomize()
	attackTimer.start()


func _on_attack_timer_timeout() -> void:
	if GameManager.enemy_is_attacking(self):
		GameManager.remove_attacking_enemy(self)


func _on_tree_exiting() -> void:
	if GameManager.enemy_is_attacking(self):
		GameManager.remove_attacking_enemy(self)

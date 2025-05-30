extends Node2D

onready var charge = $ChargeTimer
onready var sprite = $Sprite
onready var shootSFX = $ShootSFX
onready var hank = owner

export var bullets := 8
export var spread := 12
export var flashTime := .8
export var damage := 45

const BULLET = preload("res://Entities/Enemies/EnemyBullet/EnemyBullet.tscn")


func _process(_delta: float) -> void:
	sprite.material.set_shader_param("isOn", 0)
	if charge.is_stopped():
		sprite.scale = Vector2(-1, 1)
		return
	if charge.time_left < flashTime:
		sprite.material.set_shader_param("isOn", 1)
	sprite.scale.x = clamp(charge.time_left / charge.wait_time, .6, INF)
	sprite.scale.y = 1 + (1 - sprite.scale.x)
	sprite.scale.x *= -1


func attack() -> bool:
	if !charge.is_stopped(): return false
	charge.start()
	return true


func shoot() -> void:
	for i in bullets:
		var newBullet = BULLET.instance()
		var dir = global_position.direction_to(GameManager.player.global_position)
# warning-ignore:integer_division
		dir = dir.rotated(deg2rad((-spread * (bullets / 2)) + (i * spread)))
		
		newBullet.direction = dir
		newBullet.global_position = global_position + (newBullet.direction * 24)
		newBullet.speed = 100
		newBullet.damage = damage

		GameManager.spawnManager.spawn_object(newBullet)
		
		hank.bullets.append(newBullet)
		shootSFX.play()


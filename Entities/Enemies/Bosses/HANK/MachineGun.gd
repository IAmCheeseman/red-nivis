extends Node2D

onready var cooldown = $BulletCooldown
onready var sprite = $Sprite
onready var shootSFX = $ShootSFX
onready var hank = owner

export var totalShots := 30
export var damage := 20
var shots := 0

const BULLET = preload("res://Entities/Enemies/EnemyBullet/EnemyBullet.tscn")


func _process(delta: float) -> void:
	sprite.scale = sprite.scale.abs().move_toward(Vector2.ONE, 5 * delta)
	sprite.scale.x *= -1


func attack() -> bool:
	if !cooldown.is_stopped(): return false
	shots = 0
	cooldown.start()
	return true


func shoot() -> void:
	var newBullet = BULLET.instance()
	newBullet.direction = global_position.direction_to(GameManager.player.global_position)
	newBullet.global_position = global_position + (newBullet.direction * 24)
	newBullet.speed = 100
	newBullet.damage = damage
	
	GameManager.spawnManager.spawn_object(newBullet)
	
	hank.bullets.append(newBullet)
	
	sprite.scale = Vector2(1.5, .5)
	
	shootSFX.play()
	
	shots += 1
	if shots > totalShots:
		cooldown.stop()

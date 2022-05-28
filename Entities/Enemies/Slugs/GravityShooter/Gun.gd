extends Node2D

onready var sprite = $Sprite
onready var cooldown = $Cooldown
onready var attackTimer = $AttackTimer
onready var barrelEnd = $BarrelEnd

var bullet = preload("res://Entities/Enemies/EnemyBullet/Falling/FallingEnemyBullet.tscn")

var player: Node2D

var attacking := false
var shots := 0


func _process(delta: float) -> void:
	if !player: return
	
	look_at(player.global_position - Vector2(0, 64))
	
	sprite.flip_v = Vector2.RIGHT.rotated(rotation).x < 0
	
	sprite.scale = sprite.scale.move_toward(Vector2.ONE, 5 * delta)


func shoot() -> void:
	if !player or !attacking: return
	if abs(player.global_position.x - global_position.x) < 32: return
	
	owner.vel = -Vector2.RIGHT.rotated(rotation)*250
	
	var dir = Vector2.RIGHT.rotated(rotation + deg2rad(rand_range(-3, 3)) )
	
	var newBullet = bullet.instance()
	newBullet.direction = dir
	newBullet.speed = 250
	newBullet.damage = 1
	newBullet.global_position = barrelEnd.global_position
	GameManager.spawnManager.spawn_object(newBullet)
	
	sprite.scale = Vector2(1.5, 0.5)
	
	shots += 1
	if shots >= 3:
		shots = 0
		attacking = false


func _on_cooldown_timeout() -> void:
	attacking = true

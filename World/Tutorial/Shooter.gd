extends Node2D

onready var anim = $AnimationPlayer


func start() -> void:
	anim.play("Life")


func shoot() -> void:
	var bullet = preload("res://Entities/Enemies/EnemyBullet/EnemyBullet.tscn").instance()
	bullet.direction = Vector2.DOWN
	bullet.speed = 80
	bullet.global_position = global_position + Vector2(8, 16)
	GameManager.spawnManager.spawn_object(bullet)
	

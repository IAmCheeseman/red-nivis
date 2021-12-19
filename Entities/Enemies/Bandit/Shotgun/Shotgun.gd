extends Node2D

onready var sprite = $Sprite
onready var PEWPEWTIERWOOO = $PewPewTiemr
onready var barrelEnd = $BarrelEnd

var bullet = preload("res://Entities/Enemies/EnemyBullet/EnemyBullet.tscn")

var player: Node2D


func _process(delta: float) -> void:
	if !player: return
	look_at(player.global_position-Vector2(0, 8))
	sprite.flip_v = Vector2.RIGHT.rotated(rotation).x < 0


func shoot() -> void:
	if !player: return
	if global_position.distance_to(player.global_position) < 32:
		return
	var spread = 12
	get_parent().vel = -Vector2.RIGHT.rotated(rotation)*250
	for i in 3:
		var angle = i-1
		angle *= spread
		var dir = Vector2.RIGHT.rotated(deg2rad(angle)+rotation)
		
		var newBullet = bullet.instance()
		newBullet.direction = dir
		newBullet.speed = 130
		newBullet.damage = 1
		newBullet.global_position = barrelEnd.global_position
		GameManager.spawnManager.spawn_object(newBullet)
		

extends Node2D

var player: Node2D

onready var sprite = $Sprite
onready var cooldownTimer= $Timer

var bullet = preload("res://Entities/Enemies/EnemyBullet/GnomeBullet/GnomeBullet.tscn")
var bulletRot: float


func _process(_delta: float) -> void:
	if !player: return
	look_at(player.global_position - Vector2(0, 8))
	sprite.scale.y = -1 if Vector2.RIGHT.rotated(rotation).x < 0 else 1
	position.x = -1 if sprite.scale.y == -1 else 0


func shoot(times: int=6) -> void:
	if times <= 0: return
	elif times == 6:
		bulletRot = sprite.global_rotation
	
	var newBullet = bullet.instance()
	newBullet.direction = Vector2.RIGHT.rotated(sprite.global_rotation)
	newBullet.speed = 125
	newBullet.damage = 1
	newBullet.global_position = sprite.global_position
	GameManager.spawnManager.spawn_object(newBullet)
	
	var timer = get_tree().create_timer(.1)
	timer.connect("timeout", self, "shoot", [times - 1])

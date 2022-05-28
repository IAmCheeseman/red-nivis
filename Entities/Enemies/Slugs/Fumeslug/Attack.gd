extends Node2D

const BULLET = preload("res://Entities/Enemies/Slugs/Fumeslug/Gas.tscn")

onready var attackTimer = $AttackTimer


var player
var on := false


func _process(delta: float) -> void:
	if on:
		get_parent().vel.x = 0
		get_parent().vel.y = Globals.GRAVITY


func attack() -> void:
	if abs(player.global_position.x - global_position.x) < 32: return
	on = true
	yield(TempTimer.timer(self, 1), "timeout")
	
	for i in 5:
		var newBullet = BULLET.instance()
		newBullet.global_position = global_position - Vector2(0, 8)
		newBullet.speed = 100
		newBullet.damage = 1
		newBullet.direction = Vector2.UP.rotated(rand_range(-PI/2, PI/2))
		newBullet.peircing = true
		
		GameManager.spawnManager.spawn_object(newBullet)
	
	on = false
	
	attackTimer.start(rand_range(3, 4))


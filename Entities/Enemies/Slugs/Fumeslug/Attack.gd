extends Node2D

const BULLET = preload("res://Entities/Enemies/Slugs/Gasser/Gas.tscn")

onready var attackTimer = $AttackTimer

var bullets := []

var player
var on := false


func _process(delta: float) -> void:
	for i in bullets:
		if !is_instance_valid(i.node):
			bullets.erase(i)
			continue
		
		i.time += delta
		if i.time > 3:
			var node = i.node
			node.direction = node.global_position.direction_to(global_position)
			node.speed = 100
			
			if node.global_position.distance_to(global_position) < 5:
				node.queue_free()
				bullets.erase(i)
	
	if on:
		get_parent().vel.x = 0
		get_parent().vel.y = Globals.GRAVITY


func attack() -> void:
	on = true
	yield(TempTimer.timer(self, 1), "timeout")
	
	for i in 3:
		yield(TempTimer.timer(self, 0.1), "timeout")
		
		var newBullet = BULLET.instance()
		newBullet.global_position = global_position - Vector2(0, 8)
		newBullet.speed = 350 * randf()
		newBullet.direction = Vector2.UP.rotated(rand_range(-PI/2, PI/2))
		
		GameManager.spawnManager.spawn_object(newBullet)
		
		bullets.append({ "node" : newBullet, "time" : 0.0 })
		
		get_parent().sprite.scale = Vector2(1.1, 0.9)
	
	on = false
	
	attackTimer.start(rand_range(3, 4))



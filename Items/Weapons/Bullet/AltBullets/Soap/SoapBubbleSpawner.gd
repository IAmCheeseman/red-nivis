extends Node2D

onready var timer = $Timer


func spawn_bubble() -> void:
	var newBubble = preload("res://Items/Weapons/Bullet/AltBullets/AoEBullet/AoEBullet.tscn").instance()
	newBubble.position = global_position
	newBubble.direction = -owner.direction.rotated(deg2rad(rand_range(-90, 90)))
	newBubble.speed = owner.speed / 25
	newBubble.frict = .2
	newBubble.lifetime = 3
	newBubble.scale = Vector2.ONE * .5
	newBubble.damage = owner.damage * 2
	newBubble.peircing = true
	newBubble.hide()
	GameManager.spawnManager.spawn_object(newBubble)
	yield(TempTimer.idle_frame(self), "timeout")
	newBubble.set_texture(preload("res://Items/Weapons/Bullet/AltBullets/Soap/Bubble.png"))
	newBubble.particles.hide()
	newBubble.show()

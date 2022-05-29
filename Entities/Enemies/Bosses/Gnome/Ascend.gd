extends Node2D


onready var timer = $Timer

var player: Node2D
var gnome: Node2D


func test(g: Node2D) -> bool:
	gnome = g
	if timer.is_stopped():
		gnome.state = gnome.ASCEND
		timer.start()
		return true
	return false


func stop() -> void:
	if gnome:
		if gnome.state != gnome.ASCEND: return
		gnome.state = gnome.TARGET
		gnome.vel.y = -400
		
		var bulletCount := 16.0
		
		for i in bulletCount:
			var angle = deg2rad(360 * (float(i) / bulletCount))
			var dir = Vector2.RIGHT.rotated(angle)
			
			var newStick = preload("res://Entities/Enemies/Bosses/Gnome/Stick.tscn").instance()
			newStick.global_position = global_position
			newStick.direction = dir
			newStick.speed = 175
			
			GameManager.spawnManager.spawn_object(newStick)

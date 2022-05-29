extends Node2D

var player: Node2D
var gnome: Node2D


func shoot() -> void:
	var newStick = preload("res://Entities/Enemies/Bosses/Gnome/Stick.tscn").instance()
	var dir = global_position.direction_to(player.global_position - Vector2(0, 8))
	
	newStick.global_position = global_position + (dir * 16)
	newStick.direction = dir
	newStick.speed = 150
	
	GameManager.spawnManager.spawn_object(newStick)
	
	gnome.sticks.append(newStick)

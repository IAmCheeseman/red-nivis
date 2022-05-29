extends Node2D


var player: Node2D
var gnome: Node2D
var enabled := false


func attack() -> void:
	if !player or !enabled or gnome.state in [gnome.DEAD]: return
	
	var newPortal = preload("res://Entities/Enemies/Bosses/Gnome/Portal.tscn").instance()
	var pos = player.global_position + Vector2.UP.rotated(rand_range(-PI / 1.5, PI / 1.5)) * 64
	
	newPortal.global_position = pos
	newPortal.player = player
	newPortal.gnome = gnome
	GameManager.spawnManager.spawn_object(newPortal)

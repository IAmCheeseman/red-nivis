extends "res://Entities/Enemies/Goblins/Goblin.gd"


func attack_state(delta: float) -> void:
	if !player: return
	
	targetPos = player.global_position
	move_state(delta)

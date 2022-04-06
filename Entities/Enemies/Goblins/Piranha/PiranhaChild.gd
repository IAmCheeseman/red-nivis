extends "res://Entities/Enemies/Goblins/Goblin.gd"


func attack_state(delta: float) -> void:
	if !player: return
	
	targetPos = player.global_position + Vector2(0, -8)
	move_state(delta)

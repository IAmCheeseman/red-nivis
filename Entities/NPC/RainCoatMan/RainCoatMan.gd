extends "res://Entities/NPC/NPC.gd"

const BOMB = 2


func _add_states() -> void:
	states.append("bomb_state")


func bomb_state(delta: float) -> void:
	pass


func _on_dialog_signal(signalName: String) -> void:
	match signalName:
		"bomb":
			state = BOMB
			anim.play("Press")


func _on_dialog_timer_done(currentDialog) -> void:
	state = WALK

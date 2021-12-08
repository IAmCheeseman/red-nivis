extends Node2D

onready var anim = $AnimationPlayer
onready var sprite = $Sprite
onready var shakeTimer = $ShakeTimer
onready var interaction = $Iteraction

var ending := false


func _on_interaction() -> void:
	anim.play("BuildUp")
	GameManager.emit_signal(
		"zoom_in", .75, 3,
		global_position-Vector2(0, sprite.texture.get_height()/2/sprite.vframes)
	)
	interaction.disabled = true


func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "BuildUp" and !ending:
		anim.play("Shake")
		shakeTimer.start()
	elif ending:
		ending = false
		anim.play("RESET")


func _on_shake_timer_timeout() -> void:
	GameManager.emit_signal("screenshake", 2, 4, .025, .025*3)
	anim.play_backwards("BuildUp")
	ending = true

extends Node2D

onready var anim = $AnimationPlayer
onready var sprite = $Sprite
onready var shakeTimer = $ShakeTimer
onready var interaction = $Iteraction
onready var itemSpawn = $ItemSpawn
onready var lightTween = $Light/Tween
onready var light = $Light
onready var humSFX = $HumSFX
onready var dingSFX = $DingSFX

var ending := false
var worldPos = GameManager.worldData.position

signal done

func _ready() -> void:
	if GameManager.worldData.rooms.size() > 0:
		yield(TempTimer.idle_frame(self), "timeout")
		interaction.disabled = GameManager.worldData.get_room_data(self, false)
	light.energy = 0


func _on_interaction() -> void:
	anim.play("BuildUp")
	GameManager.emit_signal(
		"zoom_in", .75, 2, .2,
		global_position-Vector2(0, sprite.texture.get_height()/2/sprite.vframes)
	)
	interaction.disabled = true
	GameManager.worldData.store_room_data(self, true)


func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "BuildUp" and !ending:
		anim.play("Shake")
		lightTween.interpolate_property(
			light,
			"energy",
			0,
			2,
			.2
		)
		shakeTimer.start()
		lightTween.start()
		humSFX.play()
	elif ending:
		ending = false
		anim.play("RESET")
		lightTween.interpolate_property(
			light,
			"energy",
			2,
			0,
			.5
		)
		lightTween.start()
		emit_signal("done")
		#dingSFX.play()


func _on_shake_timer_timeout() -> void:
	GameManager.emit_signal("screenshake", 2, 4, .025, .025*3)
	anim.play_backwards("BuildUp")
	itemSpawn.add_item()
	ending = true

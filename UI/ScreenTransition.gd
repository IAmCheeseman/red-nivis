extends CanvasLayer

onready var anim = $AnimationPlayer
onready var trans = $ScreenTransition

func _ready():
	trans.material.set_shader_param("progress", 1.5)
	anim.play("RESET")
	_in()


func out() -> void:
	anim.stop(true)
	anim.play("Out")


func _in() -> void:
	anim.play_backwards("Out")

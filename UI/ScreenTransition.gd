extends CanvasLayer


onready var anim = $AnimationPlayer


func _ready():
	anim.play("RESET")
	_in()


func out() -> void:
	anim.stop(true)
	anim.play("Out")


func _in() -> void:
	anim.play_backwards("Out")

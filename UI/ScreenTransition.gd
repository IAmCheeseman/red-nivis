extends CanvasLayer


onready var anim = $AnimationPlayer


func _ready():
	_in()


func out() -> void:
	anim.play("Out")


func _in() -> void:
	anim.play_backwards("Out")

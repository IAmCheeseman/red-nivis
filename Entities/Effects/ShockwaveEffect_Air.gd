extends CanvasLayer

onready var forcetwn = $ForceTween
onready var sizetwn = $SizeTween
onready var effect = $Effect

var force := 1
var finalSize := .2
var time := .2
var position := Vector2.ZERO


func _ready() -> void:
	forcetwn.interpolate_property(
		effect.material, "shader_param/force",
		force, 0, time, Tween.TRANS_EXPO
	)
	sizetwn.interpolate_property(
		effect.material, "shader_param/size",
		0, finalSize, time
	)
	
	forcetwn.start()
	sizetwn.start()


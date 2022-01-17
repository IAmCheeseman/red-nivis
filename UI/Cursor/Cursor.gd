extends Sprite

export var rotAmount := 90.0
export var scaleSpeed:float = 2

onready var tween = $Tween

var target := 0.0


func _ready():
	yield(get_tree(), "idle_frame")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _process(delta):
	scale = scale.move_toward(Vector2.ONE, scaleSpeed*delta)
	if !GameManager.usingController or get_tree().paused or GameManager.inGUI:
		global_position = get_global_mouse_position()


func rotate_cursor(time:float):
	target += rotAmount
	if tween.is_active():
		tween.stop_all()
		target += rotAmount * 2
	tween.interpolate_property(self, "rotation_degrees",
	rotation_degrees, target, time+.2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
	scale = Vector2.ONE*1.5


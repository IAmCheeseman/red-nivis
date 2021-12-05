extends Sprite

export var rotAmount := 90.0
export var scaleSpeed:float = 1

onready var tween = $Tween

var target = 0


func _ready():
	yield(get_tree(), "idle_frame")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _process(delta):
	scale = scale.move_toward(Vector2.ONE, scaleSpeed*delta)
	if !GameManager.usingController or get_tree().paused:
		global_position = get_global_mouse_position()


func rotate_cursor(time:float):
	target += rotAmount
	if tween.is_active():
		tween.stop_all()
		target += rotAmount
	tween.interpolate_property(self, "rotation_degrees",
	rotation_degrees, target, time-.05)
	tween.start()


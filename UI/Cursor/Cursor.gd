extends Sprite

export var rotAmount := 90.0
export var scaleSpeed:float = 1

onready var tween = $Tween

var target = 0


func _ready():
	yield(get_tree(), "idle_frame")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _process(delta):
#	rotation += rotSpeed*delta
	scale = scale.move_toward(Vector2.ONE, scaleSpeed*delta)
	global_position = get_global_mouse_position()


func rotate_cursor(time:float):
	target += rotAmount
	if tween.is_active():
		tween.stop_all()
		target += rotAmount
	tween.interpolate_property(self, "rotation_degrees",
	rotation_degrees, target, time)
	tween.start()


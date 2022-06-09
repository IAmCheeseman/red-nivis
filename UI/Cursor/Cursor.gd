extends Sprite

export var rotAmount := 90.0
export var scaleSpeed:float = 2

onready var tween = $Tween
onready var reloadBar = $"../TextureProgress"

var target := 0.0


func _ready():
	yield(get_tree(), "idle_frame")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _process(delta):
	scale = scale.move_toward(Vector2.ONE, scaleSpeed*delta)
	global_position = get_global_mouse_position()
	
	reloadBar.rect_global_position = global_position + Vector2(-5, 8)


func rotate_cursor(time:float, amt:float=rotAmount):
	target += amt
	if tween.is_active():
		tween.stop_all()
	tween.interpolate_property(self, "rotation_degrees",
	rotation_degrees, target, time+.2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
	scale = Vector2.ONE*1.5


func set_reload_bar(amt: float) -> void:
	reloadBar.value = amt
	reloadBar.show()
	if reloadBar.value == 1: reloadBar.hide()

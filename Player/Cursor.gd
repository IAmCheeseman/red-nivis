extends Sprite


#
#func _ready():
#	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _process(delta):
	global_position = get_global_mouse_position()
	rotation_degrees += 30*delta

	scale = lerp(scale, Vector2.ONE, 7*delta)
	if Input.is_mouse_button_pressed(1):
		scale = Vector2.ONE*1.2
	elif Input.is_mouse_button_pressed(2):
		scale = Vector2.ONE/1.2

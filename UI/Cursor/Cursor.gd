extends Sprite

export var rotSpeed = 1
export var scaleSpeed = 1


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _process(delta):
	rotation += rotSpeed*delta
	scale = scale.move_toward(Vector2.ONE, scaleSpeed*delta)
	global_position = get_global_mouse_position()

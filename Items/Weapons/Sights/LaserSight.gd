extends Line2D

onready var rayCast = $RayCast2D

var lastFrame = Vector2.ZERO

func _physics_process(_delta):
#	look_at(get_global_mouse_position())
	var collisionPoint = to_local(rayCast.get_collision_point())
	if !rayCast.is_colliding():
		collisionPoint = rayCast.cast_to
	clear_points()
	add_point(Vector2.ZERO)
	add_point(collisionPoint)
	lastFrame = collisionPoint

func set_laser(on : bool):
	visible = on

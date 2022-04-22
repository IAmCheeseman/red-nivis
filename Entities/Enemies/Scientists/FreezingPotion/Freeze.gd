extends KinematicBody2D


onready var raycast = $RayCast2D


var vel := Vector2.ZERO
var friction := rand_range(5, 8)


func _process(delta: float) -> void:
	vel = vel.move_toward(Vector2.ZERO, friction * delta)
	if vel.is_equal_approx(Vector2.ZERO): queue_free()
	
	raycast.cast_to = vel.normalized() * 8
	raycast.force_raycast_update()
	if raycast.is_colliding():
		vel = vel.bounce(raycast.get_collision_normal())
	
	vel = move_and_slide(vel)

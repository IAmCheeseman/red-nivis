extends KinematicBody2D


var vel := Vector2.ZERO

func _physics_process(delta: float) -> void:
	vel.y += Globals.GRAVITY*delta
	
	vel.y = move_and_slide(vel).y

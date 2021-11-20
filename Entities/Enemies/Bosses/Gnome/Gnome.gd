extends KinematicBody2D

onready var jumpTimer = $Timers/JumpTimer

export var jumpForce:int = 400

var vel := Vector2.ZERO

func _physics_process(delta: float) -> void:
	vel.y += Globals.GRAVITY*delta
	
	vel.y = move_and_slide(vel).y


func _on_jump_timer_timeout() -> void:
	#if !is_on_floor(): return
	vel.y = -jumpForce
	jumpTimer.start(rand_range(1, 2))

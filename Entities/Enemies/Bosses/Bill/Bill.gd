extends KinematicBody2D

const FBOMB = preload("res://Entities/Enemies/Bosses/Bill/FBomb.tscn")

onready var fbombTimer = $Timers/FBomb

export var speed := 50.0
export var accel := 2.0

var vel := Vector2.ZERO


func _physics_process(delta: float) -> void:
	var target = GameManager.player.global_position - Vector2(0, 100)
	var dir    =                global_position.direction_to(target ) * speed
	vel.x      =                lerp(vel.x, dir.x, accel * delta    )
	vel.y      =                lerp(vel.y, dir.y, accel * delta * 8)
	
	vel = move_and_slide(vel)

# 121px
func fBomb() -> void:
	var pos := global_position - Vector2(121 / 2, 0)
	for i in 2:
		var newFBomb = FBOMB.instance()
		newFBomb.global_position = pos
		GameManager.spawnManager.spawn_object(newFBomb)
		pos.x += 121
	fbombTimer.start(rand_range(1, 2))

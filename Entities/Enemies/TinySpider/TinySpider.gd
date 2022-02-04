extends KinematicBody2D

enum { WANDER, ATTACK }

onready var sprite := $Sprite
onready var anim := $AnimationPlayer

onready var jumpTimer := $JumpTimer

export var frict := 20
export var speed := 90
export var attackTimeRange := Vector2(1, 2)


var state := WANDER
var vel := Vector2.ZERO
var target := 0.0


# warning-ignore:unused_signal
signal dead


func _process(delta: float) -> void:
	vel.y += Globals.GRAVITY * delta
	match state:
		WANDER:
			var dir = 1 if global_position.x < target else -1
			sprite.scale = sprite.scale.abs().move_toward(Vector2.ONE, 5 * delta)
			
			target = GameManager.player.global_position.x
			vel.x = dir * speed
			sprite.scale.x *= -dir
			
			if abs(global_position.x - target) <= 10 and rand_range(0, 1) < .05:
				state = ATTACK
			anim.play("Walk")
			
			vel.y = move_and_slide(vel * Vector2(rand_range(.1, 1), 1)).y
		ATTACK:
			vel.x = lerp(vel.x, 0, frict * delta)
			anim.play("Attack", -1, 2)
			
			vel.y = move_and_slide(vel * Vector2(rand_range(.1, 1), 1)).y


func wander() -> void:
	state = WANDER



func jump() -> void:
	vel.y = -200
	jumpTimer.start(rand_range(.5, 2))

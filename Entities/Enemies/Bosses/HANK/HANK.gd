extends KinematicBody2D

onready var player := GameManager.player

onready var sprite = $Sprite
onready var anim = $AnimationPlayer

onready var jumpTimer := $Timers/Jump

onready var groundCollider := $GroundCollider

export var frict := 20
export var jumpForce := 360
export var speed := 90

var vel := Vector2.ZERO


func _process(delta: float) -> void:
	vel.y += Globals.GRAVITY * delta
	if is_grounded():
		vel.x = lerp(vel.x, 0, frict * delta)
		anim.play("Idle")
	var faceDir = 1 if vel.x  < 0 else -1
	sprite.scale.x = faceDir
	
	vel.y = move_and_slide(vel).y


func jump() -> void:
	jumpTimer.start(rand_range(1, 4))
	if !is_grounded(): return
	vel.y = -jumpForce
	vel.x = -1 if Utils.coin_flip() else 1
	vel.x *= speed


func is_grounded() -> bool: return groundCollider.is_colliding()

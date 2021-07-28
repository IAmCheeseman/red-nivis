extends KinematicBody2D

enum states {IDLE, JUMPING}

export var jumpForce:int = 750
export var terminalVelocity:int = 750
export var speed:int = 120
export var friction:int = 750
export var pauseRange:Vector2 = Vector2(.5, 1.2)
export var landingScene:PackedScene
export var jumpingScene:PackedScene

onready var groundDetection = $GroundDetectors
onready var playerDetection = $PlayerDetection
onready var jumpPause = $JumpPause
onready var anim = $AnimationPlayer

var player:Node2D

var vel:Vector2 = Vector2.ZERO

var state setget set_state


func _ready():
	state = states.IDLE


func _process(delta):
	vel.y += GameManager.gravity*delta
	# State code
	match state:
		states.IDLE:
			anim.play("Idle")
			vel.x = 0#lerp(vel.x, 0, friction*delta)
		states.JUMPING:
			anim.play("Jump")
			if is_on_ground(): state = states.IDLE
	vel.y = move_and_slide(vel, Vector2.UP).y


func is_on_ground() -> bool:
	for gd in groundDetection.get_children():
		if gd.is_colliding(): return true
	return false


func set_state(value):
	# Jump
	if value == states.JUMPING and is_on_ground():
		vel.y = -jumpForce
		vel.x = round(rand_range(-1, 1))*speed
		position.y -= 10
		if jumpingScene:
			var newJumpScene = jumpingScene.instance()
			newJumpScene.position = position
			GameManager.spawnManager.spawn_object(newJumpScene)
	# Idle
	if value == states.IDLE and state == states.JUMPING:
		jumpPause.start(rand_range(pauseRange.x, pauseRange.y))
		if landingScene:
			var newIdleScene = landingScene.instance()
			newIdleScene.position = position
			GameManager.spawnManager.spawn_object(newIdleScene)
	state = value


func _on_jump_pause_timeout():
	state = states.JUMPING

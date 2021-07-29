extends KinematicBody2D

enum {IDLE, JUMPING}

export var jumpForce:int = 320
export var forceRange:Vector2 = Vector2(-200, 0)
export var terminalVelocity:int = 750
export var speed:int = 120
export var speedRange:Vector2 = Vector2(-30, 30)
export var friction:int = 750
export var pauseRange:Vector2 = Vector2(.5, 1.2)
export var landingScene:PackedScene
export var jumpingScene:PackedScene

onready var groundDetection = $GroundDetectors
onready var playerDetection = $PlayerDetection
onready var jumpPause = $JumpPause
onready var anim = $AnimationPlayer
onready var gdTimer = $GroundDetectDisable

var player:Node2D

var vel:Vector2 = Vector2.ZERO

var state = IDLE setget set_state


func _process(delta):
	vel.y += GameManager.gravity*delta
	# State code
	match state:
		IDLE:
			anim.play("Idle")
			vel.x = 0
		JUMPING:
			anim.play("Jump")
			if is_on_ground(): set_state(IDLE)
	if !player: player = playerDetection.get_player()

	vel.y = move_and_slide(vel, Vector2.UP).y


func is_on_ground() -> bool:
	for gd in groundDetection.get_children():
		if gd.is_colliding(): return true
	return false


func set_state(value):
	# Jump
	if value == JUMPING and is_on_ground():
		vel.y = -jumpForce-rand_range(forceRange.x, forceRange.y)
		vel.x = round(rand_range(-1, 1))*speed
		if player:
			var dir = global_position.direction_to(player.global_position).normalized().x
			dir *= speed+rand_range(speedRange.x, speedRange.y)
			vel.x = dir
		jumpPause.stop()
		gdTimer.start()
		set_ground_detect_state(false)
		if jumpingScene:
			var newJumpScene = jumpingScene.instance()
			newJumpScene.position = position
			GameManager.spawnManager.spawn_object(newJumpScene)
	# Idle
	if value == IDLE and state == JUMPING:
		jumpPause.start(rand_range(pauseRange.x, pauseRange.y))
		if landingScene:
			var newIdleScene = landingScene.instance()
			newIdleScene.position = position
			GameManager.spawnManager.spawn_object(newIdleScene)
	state = value


func set_ground_detect_state(gdstate:bool):
	for gd in groundDetection.get_children():
		gd.enabled = gdstate


func _on_jump_pause_timeout():
	set_state(JUMPING)

extends KinematicBody2D

enum states {IDLE, JUMPING}

export var jumpForce:int = 750
export var speed:int = 120
export var pauseRange:Vector2 = Vector2(.5, 1.2)
export var landingScene:PackedScene
export var jumpingScene:PackedScene

onready var groundDetection = $GroundDetectors
onready var playerDetection = $PlayerDetection
onready var jumpPause = $JumpPause

var player:Node2D

var state = states.IDLE setget set_state


func _process(delta):
	match state:
		states.IDLE:
			idle_state(delta)
		states.JUMPING:
			jumping_state(delta)


func jumping_state(delta):
	pass


func idle_state(delta):
	pass


func set_state(value):
	# Adding in a jumping scene
	if value == states.JUMPING and jumpingScene:
		var newJumpScene = jumpingScene.instance()
		newJumpScene.position = position
		GameManager.spawnManager.spawn_object(newJumpScene)
	# Adding in a landing scene
	if value == states.IDLE and state == states.JUMP and landingScene:
		var newIdleScene = landingScene.instance()
		newIdleScene.position = position
		GameManager.spawnManager.spawn_object(newIdleScene)
		jumpPause.start(rand_range(pauseRange.x, pauseRange.y))
	state = value


func _on_jump_pause_timeout():
	state = states.JUMPING








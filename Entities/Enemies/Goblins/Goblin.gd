extends KinematicBody2D

enum states { IDLE, MOVE, ATTACK }

onready var sprite = $Sprite
onready var anim = $AnimationPlayer

onready var playerDetection = $Collisions/PlayerDetection
onready var wallDetection = $Collisions/Wall

onready var stateChangeTimer = $Timers/StateChange

export var targetRange := 150
export var frict := 5.0
export var accel := 7.0
export var speed := 70.0
export var lookAtSwim := true

var player: Node2D
var state = states.IDLE

var vel := Vector2.ZERO
var targetPos := global_position


func _ready() -> void:
	assert(anim.has_animation("Idle"))
	assert(anim.has_animation("Swim"))


func _process(delta: float) -> void:
	if !player:
		player = playerDetection.get_player()
		anim.play("Idle")
	else:
		match state:
			states.IDLE:
				idle_state(delta)
			states.MOVE:
				move_state(delta)
			states.ATTACK:
				attack_state(delta)

		# Bouncing
		wallDetection.cast_to = vel.normalized() * (sprite.texture.get_width() / 3)
		wallDetection.force_raycast_update()
		if wallDetection.is_colliding():
			vel = vel.bounce(wallDetection.get_collision_normal())

		vel = move_and_slide(vel)


func idle_state(delta: float) -> void:
	vel = vel.move_toward(Vector2.ZERO, frict * delta)
	vel.y += Globals.WATER_GRAVITY * delta

	anim.play("Idle")


func move_state(delta: float) -> void:
	vel = vel.move_toward(
		global_position.direction_to(targetPos) * speed,
		accel * delta
	)

	if lookAtSwim:
		var currentRot = sprite.rotation - PI / 2
		sprite.look_at(targetPos)
		var targetLook = sprite.rotation
		sprite.rotation = lerp(currentRot, targetLook, (accel / 5) * delta) + PI / 2

	sprite.flip_h = vel.x > 0

	anim.play("Swim")


func attack_state(delta: float) -> void:
	pass


func get_target() -> void:
	if !player: return
	targetPos =\
		player.global_position + Vector2(rand_range(0, targetRange), 0)\
								.rotated(rand_range(0, PI * 2))


func toggle_state() -> void:
	if state == states.ATTACK: return

	if state == states.IDLE:
		state = states.MOVE
	else:
		state = states.IDLE

	stateChangeTimer.start(rand_range(1, 4))


extends KinematicBody2D
class_name BigJumpingBull

enum {ATTACK, BOUNCE, WANDER}

const stateTimes = [
	2.5,
	3,
	3.5,
	4,
	4.5,
	5,
	5.5,
	6
]

export var speed := 850
export var maxHealth := 4
export var sightDist := 16*6
export var acceleration = 2.0
export var jumpDist = 120
export var rotSpeed = 10
export var friction := 1.5

onready var sightLine = $Sight
onready var hitcast = $Hit
onready var animationPlayer = $AnimationPlayer
onready var shadow = $ScaleHelper/Sprite/Shadow
onready var sprite = $ScaleHelper/Sprite
onready var hurtAnim = $Hurt
onready var stateTimer = $StateTimer
onready var softCollision = $SoftCollision

var player : KinematicBody2D
var world
var vel = Vector2.ZERO
var lastFramePos = Vector2.ZERO
var state = WANDER setget set_state
var futurePosition = position
var targetPosRot = 0

var tiles : TileMap


func set_player(_player):
	player = _player


func set_world(_world):
	world = _world


func _physics_process(delta):
	shadow.frame = sprite.frame
	hitcast.cast_to = vel.normalized()*25
	if hitcast.is_colliding():
		vel = Vector2.ZERO
		if state == BOUNCE:
			state = ATTACK

	var distPlayer = global_position.distance_to(player.global_position)

	if distPlayer >= 16*35:
		world.enemyCount -= 1
		queue_free()

	var pushVector = softCollision.get_push_vector()
	vel += pushVector*(float(speed)/5)

# warning-ignore:return_value_discarded
	move_and_slide(vel*delta)

	AI(delta)


func set_state(value):
	state = value
	if value == BOUNCE:
		vel = global_position.direction_to(player.global_position)*(speed*2)


func AI(delta):
	if !player:
		return

	sightLine.cast_to = player.global_position-global_position

	match state:
		WANDER:
			wanderState(delta)
		ATTACK:
			attackState()
		BOUNCE:
			bounceState()


func bounceState():
	animationPlayer.play("Roll")
	shadow.global_position = sprite.global_position
	shadow.global_position.y -= sprite.position.y*2

	if stateTimer.is_stopped():
		stateTimes.shuffle()
		stateTimer.start(stateTimes[0])


func attackState():
	animationPlayer.play("Run")
	sprite.scale.x = -1 if vel.x > 0 else 1

	if stateTimer.is_stopped():
		stateTimes.shuffle()
		stateTimer.start(stateTimes[0])

	var canSeePlayer = !sightLine.is_colliding()
	if !canSeePlayer:
		state = WANDER


func jump():
	# Getting the position to jump towards
	var targetPos = Vector2.RIGHT.rotated(deg2rad(targetPosRot))*jumpDist
	targetPosRot += rotSpeed
	targetPos += player.global_position

	var jumpDir = global_position.direction_to(targetPos)
	vel = jumpDir*speed



func wanderState(delta):
	vel = vel.move_toward(Vector2.ZERO, friction*delta)
	animationPlayer.play("Idle")

	var canSeePlayer = !sightLine.is_colliding()
	if canSeePlayer:

		if global_position.distance_to(player.position) < sightDist:
			state = ATTACK


func _on_dead():
	world.enemyCount -= 1
	queue_free()


func _on_hurt():
	hurtAnim.play("Hurt")


func _on_StateTimer_timeout():
	state = BOUNCE if state == ATTACK else ATTACK
	stateTimes.shuffle()
	stateTimer.start(stateTimes[0])



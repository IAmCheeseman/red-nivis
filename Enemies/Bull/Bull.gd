extends KinematicBody2D
class_name JumpingBull

enum {ATTACK, WANDER}

export var speed := 850
export var maxHealth := 4
export var sightDist := 16*6
export var acceleration = 2.0
export var friction := 1.5

onready var sightLine = $Sight
onready var hitcast = $Hit
onready var animationPlayer = $AnimationPlayer
onready var shadow = $ScaleHelper/Sprite/Shadow
onready var sprite = $ScaleHelper/Sprite
onready var hurtAnim = $Hurt
onready var softCollision = $SoftCollision

var player : KinematicBody2D
var world
var vel = Vector2.ZERO
var target
var knowsPlayer = false
var lastFramePos = Vector2.ZERO
var state = WANDER
var futurePosition = position

var tiles : TileMap


func set_player(_player):
	player = _player


func set_world(_world):
	world = _world


func _physics_process(delta):
	shadow.frame = sprite.frame
	hitcast.cast_to = vel.normalized()*3
	if hitcast.is_colliding(): vel = Vector2.ZERO

	var distPlayer = global_position.distance_to(player.global_position)

	if distPlayer >= 16*35:
		world.enemyCount -= 1
		queue_free()

	var pushVector = softCollision.get_push_vector()
	vel += pushVector*(float(speed)/5)

# warning-ignore:return_value_discarded
	move_and_slide(vel*delta)

	AI(delta)



func jump():
	var randomness = Vector2(rand_range(-32, 32), rand_range(-32, 32))
	var dir = global_position.direction_to(player.global_position+randomness)*speed
	if rand_range(0, 5) <= 1:
		dir = -dir
	vel = dir


func AI(delta):
	if !player:
		return

	sightLine.cast_to = player.global_position-global_position

	if knowsPlayer:
		state = ATTACK

	match state:
		WANDER:
			wanderState(delta)
		ATTACK:
			target = player.global_position
			attackState(delta)


func attackState(_delta):
	knowsPlayer = true
	animationPlayer.play("Run")
	sprite.scale.x = -1 if vel.x > 0 else 1

	var canSeePlayer = !sightLine.is_colliding()
	if !canSeePlayer:
		state = WANDER



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

extends KinematicBody2D

enum states {WANDER, ATTACK, DEFEND, RETREAT}

export var speed:float = 18000
export var kbAmount:float = 320
export var accel:float = 6
export var friction:float = 3
export var wanderRange:int = 48
export var maxHealth:int = 50
export var alertDist:int = 48


onready var playerDetection = $Collisions/PlayerDetection
onready var hitbox = $Collisions/Hitbox
onready var collision = $CollisionShape2D
onready var softCollision = $Collisions/SoftCollision
onready var wanderTimer = $Timers/WanderTimer
onready var defendTimer = $Timers/DefendTimer
onready var sprite = $Sprite
onready var bounceRay = $Collisions/BounceRay
onready var healthManager = $DamageManager


var alertSignal = preload("res://Entities/Enemies/Assets/Alarm.tscn")


var vel:Vector2 = Vector2.ZERO
var targetPosition = position
var startingPosition = position

var player:Node2D
var state:int = states.WANDER

var alerted = false

# warning-ignore:unused_signal
signal death


"""
WANDER STATE:
	While the MDM does not see the player.
ATTACK STATE:
	The MDM charges at the player. Hitboxes enabled.
DEFEND STATE:
	The MDM hangs back. Hitboxes disabled.
"""

func _ready():
	wanderTimer.start(rand_range(.5, 4.5))
	startingPosition = position



func _physics_process(delta:float) -> void:
	if !player: player = playerDetection.get_player()

	if !player:
		state = states.WANDER
	elif state == states.WANDER:
		# Adding an alert signal
		var newAS = alertSignal.instance()
		newAS.position = position-Vector2(0, 12)
		GameManager.spawnManager.spawn_object(newAS)
		get_tree().call_group("MDM", "give_player", player, position)

		state = states.ATTACK

	sprite.rotation_degrees = vel.x / 6
	sprite.scale.x = -1 if vel.x > 0 else 1

	match state:
		states.WANDER:
			wander_state(delta)
		states.ATTACK:
			attack_state(delta)
		states.DEFEND:
			defend_state(delta)

	# Soft collisions
	vel += softCollision.get_push_vector()*(kbAmount*.05)

	vel = move_and_slide(vel)


func wander_state(delta:float) -> void:
	accel_to_point(targetPosition, delta)


func attack_state(delta:float) -> void:
	accel_to_point(player.global_position+(get_random_vector())*6-Vector2(0, 8), delta)


func defend_state(delta:float) -> void:
	if !defendTimer.is_stopped():
		accel_to_point(-position.direction_to(player.global_position)*32, delta)
	else:
		state = states.ATTACK if player else states.WANDER


func select_position() -> Vector2:
	var distance = rand_range(10, wanderRange)
	return startingPosition+(Vector2.RIGHT.rotated(rand_range(0, 360))*distance)


func get_random_vector() -> Vector2:
	return Vector2(randi(), randi()).normalized()


func give_player(_player:Node2D, alertNodePos:Vector2):
	if position.distance_to(alertNodePos) < alertDist: player = _player


func accel_to_point(point:Vector2, delta:float) -> void:
	# Moving the MDM
	if position.distance_to(point) > 5:
		vel = vel.move_toward(position.direction_to(point)*speed, accel*delta)
	else:
		vel = vel.move_toward(Vector2.ZERO, friction*delta)

	# Bouncing off walls and moving through platforms
	bounceRay.cast_to = vel.normalized()*sprite.texture.get_width()
	bounceRay.force_raycast_update()
	collision.disabled = false
	if bounceRay.is_colliding():
		collision.disabled = bounceRay.get_collider().is_in_group("Platform")
		if collision.disabled: return
		var normal = bounceRay.get_collision_normal()
		if vel.is_normalized(): vel = vel.bounce(normal)*.8

# Signals

func _on_wander_timer_timeout() -> void:
	if state == states.WANDER:
		targetPosition = select_position()
	wanderTimer.start(rand_range(.5, 4.5))


func _on_hit_object(_area:Area2D) -> void:
	state = states.DEFEND
	defendTimer.start()


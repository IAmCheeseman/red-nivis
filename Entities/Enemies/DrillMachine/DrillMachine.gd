extends KinematicBody2D

enum states {WANDER, ATTACK, DEFEND, RETREAT, WIND_UP}

export var speed:float = 18000
export var attackSpeed:float = 18000
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
onready var attackTimer = $Timers/AttackTimer
onready var windUpTimer = $Timers/WindUpTimer
onready var sprite = $Sprite
onready var bounceRay = $Collisions/BounceRay
onready var hpBar = $HPBar/Healthbar
onready var healthManager = $DamageManager
onready var wallHitSFX = $WallHitSFX


var alertSignal = preload("res://Entities/Enemies/Assets/Alarm.tscn")
var deathParticles = preload("res://Entities/Enemies/Assets/DeathParticles.tscn")
var healthPickup = preload("res://Items/HealthPickup/HealthPickup.tscn")

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
WIND UP STATE:
	Winding up for the attack state
ATTACK STATE:
	The MDM charges at the player. Hitboxes enabled.
DEFEND STATE:
	The MDM hangs back. Hitboxes disabled.
"""

func _ready():
	wanderTimer.start(rand_range(.5, 4.5))
	startingPosition = position
	update_healthbar()



func _physics_process(delta:float) -> void:
	if !player:
		state = states.WANDER
		player = playerDetection.get_player()
	elif state == states.WANDER:
		# Adding an alert signal
		var newAS = alertSignal.instance()
		newAS.position = position-Vector2(0, 12)
		GameManager.spawnManager.spawn_object(newAS)
		get_tree().call_group("MDM", "give_player", player, position)
		
		state = states.WIND_UP
		windUpTimer.start()
	
	if !state in [ states.WIND_UP, states.DEFEND ]: rotation = lerp_angle(rotation, 0, 2*delta)
	match state:
		states.WANDER:
			wander_state(delta)
		states.WIND_UP:
			wind_up_state(delta)
		states.ATTACK:
			attack_state(delta)
		states.DEFEND:
			defend_state(delta)
	
	hpBar.owner.global_rotation = 0
	
	# Soft collisions
	vel += softCollision.get_push_vector()*(kbAmount*.05)
	
	vel = move_and_slide(vel)


func wander_state(delta:float) -> void:
	accel_to_point(targetPosition, delta)


func attack_state(_delta:float) -> void:
	look_at(global_position+vel)
	rotation_degrees -= 90
	
	if attackTimer.is_stopped():
		vel *= .333
		state = states.DEFEND
		defendTimer.start()
	if test_move(transform, vel*.05):
		vel *= -0.333
		state = states.DEFEND
		defendTimer.start()
		wallHitSFX.play()


func wind_up_state(delta: float) -> void:
	vel = vel.move_toward(-global_position.direction_to(player.global_position)*130, accel*20*delta)
	sprite.look_at(player.global_position - Vector2(0, 8))
	sprite.rotation_degrees -= 90
	
	if windUpTimer.is_stopped():
		state = states.ATTACK
		vel = global_position.direction_to(player.global_position - Vector2(0, 8))*attackSpeed
		attackTimer.start()


func defend_state(delta:float) -> void:
	if !defendTimer.is_stopped():
		accel_to_point((-position.direction_to(player.global_position)*32)+player.global_position, delta)
	else:
		state = states.WIND_UP# if player else states.WANDER
		windUpTimer.start()


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
	
	sprite.rotation_degrees = vel.x*.7
	sprite.scale.x = -1 if vel.x > 0 else 1
	
	# Bouncing off walls and moving through platforms
	bounceRay.cast_to = vel.normalized()*sprite.texture.get_width()*.25
	bounceRay.force_raycast_update()
	collision.disabled = false
	if bounceRay.is_colliding():
		collision.disabled = bounceRay.get_collider().is_in_group("Platform")
		if collision.disabled: return
		var normal = bounceRay.get_collision_normal()
		vel = vel.bounce(normal)*.8


func update_healthbar():
	hpBar.show()
	hpBar.max_value = healthManager.maxHealth
	hpBar.value = healthManager.health


# Signals
func _on_wander_timer_timeout() -> void:
	if state == states.WANDER:
		targetPosition = select_position()
	wanderTimer.start(rand_range(.5, 1.8))


func _on_hit_object(_area:Area2D) -> void:
	state = states.DEFEND
	defendTimer.start()
	

extends KinematicBody2D

enum {IDLE, MOVE, FIRE_CHARGE, FIRE_FAST, FIRE_SHOTGUN}

# Visuals
onready var sprite = $Sprite
onready var anim = $AnimationPlayer

# Collisions
onready var playerDetection = $Collisions/PlayerDetection
onready var collisionChecker = $Collisions/CollisionChecker

# Timers
onready var fireChargeTimer = $Timers/FireChargeTimer
onready var fireCooldown = $Timers/FireCooldown
onready var fireStateTimer = $Timers/FireStateTimer
onready var walkDirChangeTimer = $Timers/WalkDirChange

# Gun
onready var gun = $Gun
onready var barrelEnd = $Gun/BarrelEnd

# Exports
export var maxSpeed := 320
export var backwardsMod := .5
export var accel := 5.0

export var fastFireCooldown := .2

export var fireShotgunCooldown := .8
export var shotgunShots := 2
export var shotgunSpread := 16

# Other variables
var state := IDLE

var speed := 0
var vel := Vector2.ZERO
var target := 0.0

var player: Node2D


func _process(delta: float) -> void:
	if !is_on_floor(): vel.y += Globals.GRAVITY
	
	# Grabbing the player
	if !player:
		player = playerDetection.get_player()
		anim.play("Idle")
	else:
		if fireStateTimer.is_stopped():
			var fireStates = [FIRE_CHARGE, FIRE_FAST, FIRE_SHOTGUN]
			state = FIRE_FAST
		# States
		match state:
			IDLE:
				vel.x = lerp(vel.x, 0, accel*delta)
				anim.play("Idle")
				if walkDirChangeTimer.is_stopped():
					select_target_x()
					state = MOVE
			MOVE:
				move_state(delta)
			FIRE_CHARGE:
				pass
			FIRE_FAST:
				fire_state(delta, "fire_fast")
			FIRE_SHOTGUN:
				pass
	move_and_slide(vel)


func fire_state(delta: float, fireFunction:String) -> void:
	vel.x = lerp(vel.x, 0, accel*delta)
	gun.look_at(player.global_position)
	anim.play("Shoot")
	
	sprite.scale.x = -1
	gun.scale.y = 1
	if player.global_position.x < global_position.x:
		sprite.scale.x = 1
		gun.scale.y = -1


func move_state(delta: float) -> void:
	if is_close_to_target():# or walkDirChangeTimer.is_stopped():
		walkDirChangeTimer.stop()
		state = IDLE
		walkDirChangeTimer.start(rand_range(2, 4))
	
	# Animation
	sprite.scale.x = -1
	if player.global_position.x < global_position.x:
		sprite.scale.x = 1
	
	if !int(global_position.x) in range(target, player.global_position.x):
		anim.play("WalkForwards")
		speed = maxSpeed
	else:
		anim.play("WalkBackwards")
		speed = maxSpeed*.75
	
	var targetv = -1 if global_position.x > target else 1
	vel.x = lerp(vel.x, targetv*speed*delta, accel*delta)


func is_close_to_target() -> bool:
	return global_position.distance_to(Vector2(target, global_position.y)) < 8


func select_target_x() -> void:
	if !player: return
	var i = 0
	while true:
		target = player.global_position.x+rand_range(-128, 128)
		
		collisionChecker.cast_to.x = target-global_position.x
		collisionChecker.force_raycast_update()
		var isColliding = collisionChecker.is_colliding()
		
		if i > 100 and !isColliding:
			break
		i += 1

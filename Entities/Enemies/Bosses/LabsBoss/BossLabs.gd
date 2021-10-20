extends KinematicBody2D

enum {IDLE, MOVE, FIRE_CHARGE, FIRE_FAST, FIRE_SHOTGUN}
const BULLET_SPEED = 90

# Visuals
onready var sprite = $Sprite
onready var anim = $AnimationPlayer
onready var hpBar = $BossBar/VBoxContainer/ProgressBar

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
export var maxHealth := 550

export var maxSpeed := 320
export var backwardsMod := .5
export var accel := 5.0

export var fastFireCooldown := .2
export var fastFireShots := 8

export var shotgunCooldown := .8
export var shotgunBullets = 4
export var shotgunSpread := 16

# Other variables
var healthPickup = preload("res://Items/HealthPickup/HealthPickup.tscn")
var bullet = preload("res://Entities/Enemies/EnemyBullet/EnemyBullet.tscn") 

var state := IDLE

onready var health = maxHealth

var speed := 0
var vel := Vector2.ZERO
var target := 0.0

var fireCount = 0

var player: Node2D


func _process(delta: float) -> void:
	if !is_on_floor(): vel.y += Globals.GRAVITY*delta
	
	# Grabbing the player
	if !player:
		player = playerDetection.get_player()
		anim.play("Idle")
	else:
		if fireStateTimer.is_stopped():
			var fireStates = [FIRE_FAST, FIRE_SHOTGUN]
			fireStates.shuffle()
			state = fireStates.pop_front()
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
				fire_state(delta)
				# Firing
				if fireCooldown.is_stopped():
					var newBullet = bullet.instance()
					newBullet.global_position = barrelEnd.global_position
					newBullet.direction = barrelEnd.global_position.direction_to(player.global_position)
					newBullet.speed = BULLET_SPEED
					
					GameManager.spawnManager.spawn_object(newBullet)
					fireCooldown.start(fastFireCooldown)
					
					fireCount += 1
					if fireCount >= fastFireShots:
						fireStateTimer.start()
						fireCount = 0
						state = IDLE
			FIRE_SHOTGUN:
				fire_state(delta)
				# Firing
				if fireCooldown.is_stopped():
					for i in shotgunBullets:
						var newBullet = bullet.instance()
						
						var dir = barrelEnd.global_position.direction_to(player.global_position)
						var spread = deg2rad(shotgunSpread*i-(shotgunSpread*(shotgunBullets-1)*.5))
						
						
						newBullet.global_position = barrelEnd.global_position
						newBullet.direction = dir.rotated(spread)
						newBullet.speed = BULLET_SPEED
						
						GameManager.spawnManager.spawn_object(newBullet)
						
					fireCooldown.start(shotgunCooldown)
					fireCount += 1
					if fireCount >= fastFireShots:
						fireStateTimer.start()
						fireCount = 0
						state = IDLE
						
	vel.y = move_and_slide(vel*delta).y


func fire_state(delta: float) -> void:
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
	vel.x = lerp(vel.x, targetv*speed, accel*delta)


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


func _on_hurt(amount, _dir) -> void:
	health -= amount
	hpBar.value = Utils.percentage_of(health, maxHealth)
	if health <= 0:
		# Dropping the hp
		var playerData = player.get_parent().playerData
		for i in playerData.maxHealth-playerData.health:
			var newHealth = healthPickup.instance()
			newHealth.position = position-Vector2(0, sprite.texture.get_height()*.25)
			var force = (Vector2.UP+Vector2(rand_range(-.25, .25), 0)).normalized()*70
			newHealth.apply_central_impulse(force)
			GameManager.spawnManager.spawn_object(newHealth)
		# Getting done
		queue_free()



extends KinematicBody2D

enum {IDLE, WANDER, ATTACK_WANDER, ATTACK_SHOOT, DEATH}

export var maxSpeed = 70
export var accelaration = 300
export var friction = 300
export var damage = 6
export var cooldown = .2
export var maxRapidShots = 3
export var accuracy = 12
export var shotSpeed = 360
export var maxWanderDist = 64
export var shotOffset = 16


onready var cooldownTimer = $CooldownTimer
onready var wanderTimer = $WanderTimer
onready var sprite = $Sprite
onready var shadow = $Shadow
onready var hitAnim = $Hurt
onready var shootSFX = $ShootSFX
onready var deathSFX = $DeathSFX


var bullet = preload("res://Enemies/EnemyBullet/EnemyBullet.tscn")
var vel = Vector2.ZERO
var state = IDLE
var rapidShots = 0
var player : Node2D
var targetPosition = Vector2.ZERO
var tiles
var world
var isDead = false


func set_player(_player):
	player = _player


func set_world(_world):
	world = _world


func _physics_process(delta):
	# State machine
	match state:
		IDLE:
			idle_state(delta)
			check_for_player()
		WANDER:
			wander_state(delta)
			check_for_player()
		ATTACK_SHOOT:
			attack_shoot_state(delta)
		ATTACK_WANDER:
			attack_wander_state(delta)
		DEATH:
			pass

	shadow.frame = sprite.frame

	# Removing itself if it's too far away
	if global_position.distance_to(player.global_position) >= 16*35:
		remove()

	sprite.scale.x = 1 if vel.x < 0 else -1

# warning-ignore:return_value_discarded
	move_and_slide(vel)


func idle_state(delta):
	# Stopping
	move_in_dir(Vector2.ZERO, friction, delta)


func wander_state(delta):
	# Move to the target position
	if global_position.distance_to(targetPosition) > 5:
		move_in_dir(global_position.direction_to(targetPosition), accelaration, delta)
	else:
		state = IDLE


func attack_wander_state(delta):
	# Move to the target position and switch back to shooting
	var distTarget = global_position.distance_to(targetPosition)
	if distTarget > 5 and !cooldownTimer.is_stopped():
		move_in_dir(global_position.direction_to(targetPosition), accelaration, delta)
	elif GameManager.attackingEnemies <= 0:
		GameManager.attackingEnemies += 1
		rapidShots = 0
		cooldownTimer.stop()
		state = ATTACK_SHOOT
	else:
		cooldownTimer.start(5)


func attack_shoot_state(delta):
	# Shoot 3 times and then move
	move_in_dir(Vector2.ZERO, friction, delta)
	if cooldownTimer.is_stopped():
		cooldownTimer.start(cooldown)
		rapidShots += 1
	if rapidShots > maxRapidShots:
		GameManager.attackingEnemies -= 1
		get_new_target_position()
		state = ATTACK_WANDER
		cooldownTimer.start(5)


func move_in_dir(dir:Vector2, weight, delta):
	vel = vel.move_toward(dir*maxSpeed, weight*delta)


func check_for_player():
	if global_position.distance_to(player.global_position) < 150:
		state = ATTACK_SHOOT
		GameManager.attackingEnemies += 1


func shoot():
	if isDead: return

	# Selects a direction for the bullet to go
	var bulletAccuracy = deg2rad(rand_range(-accuracy, accuracy))
	var dir = global_position.direction_to(player.global_position).rotated(bulletAccuracy)

	var newBullet = bullet.instance()
	newBullet.direction = dir
	newBullet.speed = shotSpeed
	newBullet.global_position = global_position+(dir*shotOffset)

	get_tree().root.get_child(3).add_child(newBullet)
	newBullet.hitbox.damage = damage

	shootSFX.play()


func _on_wander_timer_timedout():
	# Swap non-aggro states
	if state == IDLE:
		state = WANDER
		get_new_target_position()
	elif state == WANDER:
		state = IDLE

	# Restart the timer
	var time = rand_range(0.5, 4)
	wanderTimer.start(time)


func get_new_target_position():
	targetPosition = global_position+Vector2.RIGHT.rotated(rand_range(0, 360))*rand_range(maxWanderDist/2, maxWanderDist)


func remove():
	world.enemyCount -= 1
	queue_free()


func _on_death():
	deathSFX.play()
	isDead = true
	hide()


func _on_hurt():
	hitAnim.play("Hurt")

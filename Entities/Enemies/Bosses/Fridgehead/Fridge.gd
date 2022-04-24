extends KinematicBody2D

enum { WANDER, FOOD_SHOOTER, SLAM }

onready var sprite = $Sprite
onready var floorRay = $Collisions/FloorRay
onready var slamHitbox = $Collisions/SlamHitbox/CollisionShape2D

export var accel := 50.0
export var speed := 120.0

var player: Node2D

var targetPos: Vector2
var vel: Vector2

var state := WANDER

var offsets = [-80, -96]
var currentOffset = 0

var foodShots = 0


func _ready() -> void:
	yield(TempTimer.idle_frame(self), "timeout")
	get_target_pos()


func _process(delta: float) -> void:
	match state:
		WANDER:
			wander_state(delta)
		FOOD_SHOOTER:
			food_shoot(delta)
		SLAM:
			slam_state(delta)
	
	vel = move_and_slide(vel)


func tilt() -> void:
	rotation_degrees = (vel.x / speed) * 24


func get_target_pos() -> void:
	var offset = Vector2(rand_range(-64, 64), offsets[currentOffset])
	targetPos = player.global_position + offset
	
	currentOffset = wrapi(currentOffset+1, 0, offsets.size())


func attack(exclude=-1) -> void:
	if state != WANDER: return
	var attackStates = [SLAM, FOOD_SHOOTER]
	attackStates.shuffle()
	state = attackStates.pop_front()
	if state != exclude: state = attackStates.pop_front()


func wander_state(delta: float) -> void:
	var actualAccel = accel if global_position.y > targetPos.y else accel * 3
	vel = vel.move_toward(
		global_position.direction_to(targetPos) * speed,
		actualAccel * delta
	)
	tilt()
	
	if global_position.distance_to(targetPos) < 8:
		get_target_pos()
	
	sprite.frame = 0


func slam_state(delta) -> void:
	targetPos = player.global_position - Vector2(0, 64)
	vel = vel.move_toward(
		global_position.direction_to(targetPos) * speed,
		(accel * 10) * delta
	)
	look_at(player.global_position)
	rotation += PI / 2
	
	if global_position.distance_to(targetPos) < 16:
		vel = Vector2(200, 0).rotated(
			global_position.direction_to(player.global_position).angle()
		)
		rotation = 0
		slamHitbox.disabled = false
	if floorRay.is_colliding():
		vel.y = -200
		state = WANDER
		slamHitbox.disabled = true
		sprite.scale.y = 1


func food_shoot(delta: float) -> void:
	var actualAccel = accel if global_position.y > targetPos.y else accel * 3
	if global_position.distance_to(targetPos) < 8:
		actualAccel = accel * 8
	vel = vel.move_toward(
		global_position.direction_to(targetPos) * speed,
		actualAccel * delta
	)
	
	rotation = lerp(
		rotation,
		atan2(
			player.global_position.y - global_position.y,
			player.global_position.x - global_position.x
		),
		delta
	)
	
	sprite.scale.y = -1 if player.global_position.x < global_position.x else 1
	
	sprite.frame = 1


func shoot_food() -> void:
	if state != FOOD_SHOOTER: return
	
	foodShots += 1
	if foodShots >= 50:
		foodShots = 0
		state = WANDER
		sprite.scale.y = 1
	
	var bullet = preload("res://Entities/Enemies/EnemyBullet/EnemyBullet.tscn").instance()
	bullet.direction = Vector2.RIGHT.rotated(rotation)
	bullet.speed = 150
	bullet.damage = 1
	
	var offset = Vector2(1, rand_range(-10, 10)).rotated(sprite.rotation)
	bullet.global_position = global_position + Vector2(8, 16) + offset
	GameManager.spawnManager.spawn_object(bullet)


func _on_damaged() -> void:
	if state == SLAM:
		attack(SLAM)

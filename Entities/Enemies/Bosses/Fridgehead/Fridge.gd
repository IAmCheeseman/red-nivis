extends KinematicBody2D

enum { WANDER, FOOD_SHOOTER, INTRO }

onready var sprite = $Sprite
onready var floorRay = $Collisions/FloorRay
onready var slamHitbox = $Collisions/SlamHitbox/CollisionShape2D
onready var attacks = $Attacks
onready var collision = $CollisionShape2D

export var accel := 50.0
export var speed := 120.0

export(NodePath) onready var player = get_node(player) as KinematicBody2D

var targetPos: Vector2
var vel: Vector2

var state := INTRO

var offsets = [-80, -96]
var currentOffset = 0

var foodShots = 0

var isAttacking := false


func _ready() -> void:
	yield(TempTimer.idle_frame(self), "timeout")
	get_target_pos()
	
	for i in attacks.get_children():
		i.fridge = self


func _process(delta: float) -> void:
	if !isAttacking:
		match state:
			WANDER:
				wander_state(delta)
			INTRO:
				vel = Vector2(0, 700)
				if floorRay.is_colliding():
					collision.disabled = true
					vel.y = 0
					state = WANDER
	
	vel = move_and_slide(vel)


func tilt() -> void:
	rotation_degrees = (vel.x / speed) * 24


func get_target_pos() -> void:
	var offset = Vector2(rand_range(-64, 64), offsets[currentOffset])
	targetPos = player.global_position + offset
	
	currentOffset = wrapi(currentOffset+1, 0, offsets.size())


func attack() -> void:
	var attackNodes = attacks.get_children()
	attackNodes.shuffle()
	
	for i in attackNodes:
		if i.test():
			isAttacking = true


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

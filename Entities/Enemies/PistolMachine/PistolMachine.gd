extends KinematicBody2D

enum {WALK, SHOOT}

onready var playerDetection = $Collisions/PlayerDetection

onready var gun = $Gun
onready var gunSprite = $Gun/Sprite
onready var aimTimer = $Timers/Aim

onready var shootStateTimer = $Timers/Shoot

export var speed := 64.0
export var acceleration := 5.0
export var friction := 2.5
export var damage := 1

var bullet = preload("res://Entities/Enemies/EnemyBullet/EnemyBullet.tscn")

var vel := Vector2.ZERO
var targetPosition := 0.0

var state := WALK

var player: Node2D

signal dead


func _ready() -> void:
	targetPosition = global_position.x


func _process(delta: float) -> void:
	if !player: player = playerDetection.get_player()
	else:
		match state:
			WALK:
				walk_state(delta)
			SHOOT:
				shoot_state(delta)
	vel.y += Globals.GRAVITY*delta
	
	vel.y = move_and_slide(vel).y


func walk_state(delta: float) -> void:
	if global_position.distance_to(Vector2(targetPosition, global_position.y)) < 5:
		vel.x = lerp(vel.x, 0, friction*delta)
		if abs(vel.x) < .5: new_target_position()
	else:
		var targetVel = speed if global_position.direction_to(Vector2(targetPosition, global_position.y)).x > 0 else -speed
		vel.x = lerp(vel.x, targetVel, acceleration*delta)
		gun.look_at(Vector2(vel.x, 0)+gun.global_position)
		flip_gun()


func shoot_state(delta: float) -> void:
	if aimTimer.is_stopped():
		shoot()
		shootStateTimer.start(rand_range(3, 5))
		new_target_position()
		state = WALK
	vel.x = lerp(vel.x, 0, friction*delta)
	gun.look_at(player.global_position+Vector2(0, -8))
	flip_gun()


func shoot() -> void:
	var newBullet = bullet.instance()
	newBullet.direction = Vector2.RIGHT.rotated(gunSprite.global_rotation)
	newBullet.speed = 180*.5
	newBullet.damage = damage
	newBullet.global_position = gunSprite.global_position
	GameManager.spawnManager.spawn_object(newBullet)


func new_target_position() -> void:
	targetPosition = player.global_position.x+rand_range(-64, 64)


func flip_gun() -> void:
	gunSprite.flip_v = gunSprite.global_position.x < gun.global_position.x


func _on_shoot_state_timeout() -> void:
	state = SHOOT
	aimTimer.start()


func _draw() -> void:
	draw_circle(Vector2.ZERO, 8, Color.red)




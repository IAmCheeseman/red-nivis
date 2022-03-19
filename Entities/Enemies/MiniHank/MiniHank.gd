extends KinematicBody2D

enum {WALK, SHOOT}

onready var playerDetection = $Collisions/PlayerDetection

onready var sprite = $Sprite
onready var anim = $AnimationPlayer

onready var gun = $Gun
onready var gunSprite = $Gun/Sprite
onready var aimTimer = $Timers/Aim

onready var shootStateTimer = $Timers/Shoot

onready var hpBar = $Healthbar

onready var healthManager = $DamageManager

export var speed := 64.0
export var kbAmount:float = 32
export var acceleration := 5.0
export var friction := 2.5
export var damage := 1

var bullet = preload("res://Entities/Enemies/EnemyBullet/EnemyBullet.tscn")

var vel := Vector2.ZERO
var targetPosition := 0.0

var state := WALK

var player: Node2D

# warning-ignore:unused_signal
signal dead


func _ready() -> void:
	targetPosition = global_position.x

	#healthManager.maxHealth = Utils.dmg_to_hp(15, .2, 1.5)
	#healthManager.health = healthManager.maxHealth
	update_healthbar()


func _process(delta: float) -> void:
	if !player:
		player = playerDetection.get_player()
		anim.play("Idle")
		flip_sprite(Vector2.RIGHT)
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
		flip_sprite(vel)

		anim.play("Idle")
	else:
		var targetVel = speed if global_position.direction_to(Vector2(targetPosition, global_position.y)).x > 0 else -speed
		vel.x = lerp(vel.x, targetVel, acceleration*delta)
		flip_sprite(vel)

		gun.look_at(Vector2(vel.x, 0)+gun.global_position)
		flip_gun()

		anim.play("Walk")


func shoot_state(delta: float) -> void:
	if aimTimer.is_stopped():
		shoot()
		shootStateTimer.start(rand_range(1, 2))
		new_target_position()
		state = WALK
	vel.x = lerp(vel.x, 0, friction*delta)
	gun.look_at(player.global_position+Vector2(0, -8))
	flip_gun()

	flip_sprite(player.global_position)

	anim.play("Idle")


func shoot() -> void:
	if global_position.distance_to(player.global_position) < 32:
		return
	for i in 5:
		var newBullet = bullet.instance()
		newBullet.direction = Vector2.RIGHT.rotated(gunSprite.global_rotation).rotated(deg2rad(rand_range(-25, 25)))
		newBullet.speed = 100 + rand_range(-50, 20)
		newBullet.damage = damage
		newBullet.global_position = gunSprite.global_position
		GameManager.spawnManager.spawn_object(newBullet)


func flip_sprite(fv:Vector2) -> void:
	if fv.x > 0:
		sprite.scale.x = -1
		gun.position.x = -5
		hpBar.rect_position.x = -2
	else:
		sprite.scale.x = 1
		gun.position.x = 5
		hpBar.rect_position.x = -6


func update_healthbar():
	hpBar.max_value = healthManager.maxHealth
	hpBar.value = healthManager.health


func new_target_position() -> void:
	targetPosition = player.global_position.x+rand_range(-64, 64)


func flip_gun() -> void:
	gunSprite.flip_v = gunSprite.global_position.x < gun.global_position.x


func _on_shoot_state_timeout() -> void:
	state = SHOOT
	aimTimer.start()


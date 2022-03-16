extends KinematicBody2D

onready var sprite = $Sprite
onready var SaS = $SquashAndStretch

onready var playerDetection = $Collision/PlayerDetection
onready var bounceRay = $Collision/BounceRay

onready var jumpTimer = $Timers/Jump
onready var attackTimer = $Timers/Attack

onready var hpBar = $Healthbar
onready var healthManager = $DamageManager

export var jumpForce := 340
export var friction := 15

var player: Node2D

var vel := Vector2.ZERO
var jumpDir := Vector2.ZERO

var lastFrameGrounded := false


func _ready() -> void:
	update_healthbar()


func _process(delta: float) -> void:
	vel.y += Globals.GRAVITY*delta
	if !player: player = playerDetection.get_player()

	if is_on_floor(): # Apply friction if on floor
		vel.x = lerp(vel.x, 0, friction*delta)
		sprite.rotation = 0
	else: # Rotate/scale the sprite, and
		  # bounce off walls/ceilings if
		  # not on floor
		if vel.y > 0:
			sprite.scale.x = clamp(
				1-abs(vel.y/Globals.GRAVITY),
				.75, 1.5)
			sprite.scale.y = 1+(1-sprite.scale.x)
		sprite.rotation = vel.angle()-deg2rad(90)
		sprite.scale.x *= -1 if bounceRay.cast_to.x > 0 else 1

		# Bouncing
		bounceRay.cast_to = vel.normalized()*8
		bounceRay.force_raycast_update()
		if bounceRay.is_colliding():
			var normal = bounceRay.get_collision_normal()
			if normal != Vector2.UP: vel = vel.bounce(normal)*.8

	vel.y = move_and_slide_with_snap(
		vel,
		vel.normalized()*5,
		Vector2.UP,
		true,
		4,
		deg2rad(89)).y
	if !lastFrameGrounded and is_on_floor(): SaS.play("Land")
	lastFrameGrounded = is_on_floor()


func select_jump_dir() -> void:
	if Utils.coin_flip() and player: # Jump to the player
		var dist = global_position.distance_to(
			Vector2(player.global_position.x, global_position.y)
		)/200
		var dir = dist if player.global_position.x > global_position.x else -dist
		jumpDir = Vector2(dir, -1)
	else: # Jump in a random direction
		var dir = rand_range(-1, 1)
		jumpDir = Vector2(dir, -1)


func update_healthbar():
	hpBar.max_value = healthManager.maxHealth
	hpBar.value = healthManager.health


func jump() -> void:
	vel = jumpDir*jumpForce*rand_range(.9,1)
	select_jump_dir()


func _on_jump_timer_timeout() -> void:
	jumpTimer.start(rand_range(1, 2))
	jump()


func attack() -> void:
	attackTimer.start(rand_range(1, 4))
	if !player: return
	var newBullet = preload("res://Entities/Enemies/EnemyBullet/EnemyBullet.tscn").instance()
	newBullet.particleScene = preload("res://Entities/Enemies/Web/Web.tscn")
	newBullet.global_position = global_position
	newBullet.speed = 120
	newBullet.damage = 0
	newBullet.direction = global_position.direction_to(player.global_position)
	GameManager.spawnManager.spawn_object(newBullet)

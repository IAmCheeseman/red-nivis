extends KinematicBody2D

enum {IDLE, WALK} # States

onready var sprite = $Sprite
onready var anim = $AnimationPlayer

onready var stateChangeTimer = $Timers/StateChange
onready var jumpTimer = $Timers/Jump

onready var hurtbox = $Collisions/Hurtbox
onready var playerDetection = $Collisions/PlayerDetection
onready var collisionCheckerRC = $Collisions/CollisionChecker
onready var floorCheckerRC = $Collisions/FloorChecker

onready var damageManager = $DamageManager
onready var healthBar = $Healthbar

onready var gun = $Gun

export var speed := 75
export var accel := 5.0
export var frict := 10.0
export var jumpForce := 350

var state := IDLE
var targetPosition := 0

var vel := Vector2.ZERO
var player: Node2D

var prevFloorState = false

func _ready() -> void:
	select_new_target_pos()
	healthBar.max_value = damageManager.maxHealth
	healthBar.value = damageManager.maxHealth


func _physics_process(delta: float) -> void:
	vel.y += Globals.GRAVITY*delta
	
	if !player:
		player = playerDetection.get_player()
		if gun.get_script(): gun.player = player
	else:
		match state:
			IDLE:
				animate("Idle")
				vel.x = lerp(vel.x, 0, frict*delta)
				sprite.flip_h = global_position.x < player.global_position.x
			WALK:
				animate("Walk")
				var moveDir = -1 if global_position.x > targetPosition else 1
				sprite.flip_h = global_position.x < player.global_position.x
				vel.x = lerp(vel.x, moveDir*speed, accel*delta)
				
				if abs(global_position.x-targetPosition) < 5:
					_on_state_change_timeout()
	if vel.y > 0 and !floorCheckerRC.is_colliding():
		sprite.scale.x = clamp(
			1-abs(vel.y/Globals.GRAVITY),
			.75, 1.5)
		sprite.scale.y = 1+(1-sprite.scale.x)
	elif floorCheckerRC.is_colliding():
		if !prevFloorState: sprite.scale = Vector2(1.5, .5)
		sprite.scale = sprite.scale.move_toward(Vector2.ONE, 3*delta)
	
	vel.y = move_and_slide(vel).y
	
	prevFloorState = floorCheckerRC.is_colliding()


func select_new_target_pos() -> void:
	if !player: return
	for _i in 10:
		targetPosition = int(player.global_position.x + rand_range(-64, 64))
		collisionCheckerRC.cast_to.x = targetPosition - global_position.x
		collisionCheckerRC.force_raycast_update()
		if !collisionCheckerRC.is_colliding(): break


func animate(otherAnim: String) -> void:
	if !floorCheckerRC.is_colliding():
		anim.play("Fall")
	else:
		anim.play(otherAnim)


func jump() -> void:
	if floorCheckerRC.is_colliding() and player: vel.y = -jumpForce
	jumpTimer.start(rand_range(2, 4))


func _on_state_change_timeout() -> void:
	select_new_target_pos()
	if Utils.coin_flip() or state == IDLE:
		state = WALK if state == IDLE else IDLE
		stateChangeTimer.start(rand_range(.5, 1))
	else:
		stateChangeTimer.start(rand_range(.2, .5))


func update_healthbar() -> void:
	healthBar.value = damageManager.health


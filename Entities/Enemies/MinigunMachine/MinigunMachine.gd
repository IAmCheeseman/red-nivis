extends KinematicBody2D

export var speed:float = 1200
export var accel:float = 24
export var friction:float = 12
export var wanderRange:float = 48
export var kbAmount:float = .5
export var health:float = 1


onready var minigun = $ScaleHelper/Sprite/Minigun
onready var collision = $CollisionShape2D
onready var playerDetection = $Collisions/PlayerDetection
onready var softCollision = $Collisions/SoftCollision
onready var bounceRay = $Collisions/BounceRay
onready var sprite = $ScaleHelper/Sprite
onready var minigunSprite = $ScaleHelper/Sprite/Minigun/Sprite
onready var wanderTimer = $Timers/WanderTimer
onready var healthBar = $Healthbar


var deathParticles = preload("res://Entities/Enemies/Assets/DeathParticles.tscn")
var healthPickup = preload("res://Items/HealthPickup/HealthPickup.tscn")
var player:Node2D
var vel:Vector2 = Vector2.ZERO
var targetPosition:Vector2 = position
var startingPosition:Vector2 = position

signal death


func _ready() -> void:
	startingPosition = position
	health = Utils.dmg_to_hp(15, .2, 1.5)
	healthBar.max_value = health
	healthBar.value = health


func _process(delta: float) -> void:
	sprite.rotation_degrees = vel.x*.7
	sprite.flip_h = vel.x > 0
	
	if !player:
		player = playerDetection.get_player()
		healthBar.hide()
		minigun.isOn = false
	else:
		minigun.isOn = true
		minigunSprite.look_at(player.global_position)
		var angleVec:Vector2 = Vector2.RIGHT.rotated(minigunSprite.rotation)
		minigunSprite.scale.y = -1 if angleVec.x > 0 else 1
		healthBar.show()
		
	accel_to_point(targetPosition, delta)
	vel += softCollision.get_push_vector()*(kbAmount*.05)
	vel = move_and_slide(vel)


func accel_to_point(point:Vector2, delta:float) -> void:
	# Moving the MM
	if position.distance_to(point) > 5:
		vel = vel.move_toward(position.direction_to(point)*speed, accel*delta)
	else:
		vel = vel.move_toward(Vector2.ZERO, friction*delta)
	
	# Bouncing off walls and moving through platforms
	bounceRay.cast_to = vel.normalized()*sprite.texture.get_height()*.25
	bounceRay.force_raycast_update()
	collision.disabled = false
	if bounceRay.is_colliding():
		collision.disabled = bounceRay.get_collider().is_in_group("Platform")
		if collision.disabled: return
		var normal = bounceRay.get_collision_normal()
		if vel.is_normalized(): vel = vel.bounce(normal)*.8


func select_position() -> Vector2:
	var distance = rand_range(10, wanderRange)
	var addVec = startingPosition if !player else player.global_position
	return addVec+(Vector2.RIGHT.rotated(rand_range(0, 360))*distance)


func _on_wander_timer_timeout() -> void:
	targetPosition = select_position()
	wanderTimer.start(rand_range(.1, 4.5))


func _on_hurt(amount:float, dir:Vector2) -> void:
# warning-ignore:narrowing_conversion
	health -= amount
	healthBar.value = health
	vel = dir*kbAmount
	if health <= 0:
		var newDP = deathParticles.instance()
		newDP.position = position
		newDP.rotation = dir.angle()
		GameManager.spawnManager.spawn_object(newDP)
		GameManager.frameFreezer.freeze_frames(.07)
		
		if rand_range(0, 1) < Globals.HEART_CHANCE:
			var newHealth = healthPickup.instance()
			newHealth.position = position
			GameManager.spawnManager.spawn_object(newHealth)
			
		emit_signal("death")
		queue_free()
	
#	update_healthbar()

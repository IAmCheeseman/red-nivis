extends KinematicBody2D

export var speed:float = 1200
export var accel:float = 50
export var friction:float = 12
export var wanderRange:float = 48
export var kbAmount:float = .5

onready var minigun = $Sprite/Minigun
onready var collision = $CollisionShape2D
onready var playerDetection = $Collisions/PlayerDetection
onready var softCollision = $Collisions/SoftCollision
onready var bounceRay = $Collisions/BounceRay
onready var sprite = $Sprite
onready var minigunSprite = $Sprite/Minigun/Sprite
onready var wanderTimer = $Timers/WanderTimer
onready var healthManager = $DamageManager
onready var floorRay = $Collisions/FloorRay
onready var shootTimer = $Timers/ShootTimer

var deathParticles = preload("res://Entities/Enemies/Assets/DeathParticles.tscn")
var healthPickup = preload("res://Items/HealthPickup/HealthPickup.tscn")
var player: Node2D
var vel: Vector2 = Vector2.ZERO
var targetPosition: Vector2 = position
var startingPosition: Vector2 = position

# warning-ignore:unused_signal
signal death

enum State { Normal, Shoot }
var state: int = State.Normal

func _ready() -> void:
	startingPosition = position


func _process(delta: float) -> void:
	sprite.rotation_degrees = vel.x / 4
	sprite.scale.x = 1 if vel.x < 0 else -1

	if !player:
		player = playerDetection.get_player()
		minigun.isOn = false
	else:
		match state:
			State.Normal:
				minigun.start()
				
				minigunSprite.look_at(player.global_position)
				
				var angleVec:Vector2 = Vector2.RIGHT.rotated(minigunSprite.rotation)
				minigunSprite.flip_v = false if angleVec.x > 0 else true
				
				accel_to_point(targetPosition, delta)
				vel += softCollision.get_push_vector() * (kbAmount * 0.05)
				vel = move_and_slide(vel)
			State.Shoot:
				minigun.start()
				minigunSprite.look_at(player.global_position)
				
				var angleVec:Vector2 = Vector2.RIGHT.rotated(minigunSprite.rotation)
				minigunSprite.flip_v = false if angleVec.x > 0 else true
				
				accel_to_point(global_position, delta)
				vel += softCollision.get_push_vector() * (kbAmount * 0.05)
				vel = move_and_slide(vel)


func accel_to_point(point:Vector2, delta:float) -> void:
	# Moving the MM
	if position.distance_to(point) > 5:
		vel = vel.move_toward(position.direction_to(point)*speed, accel*delta)
	else:
		vel = vel.move_toward(Vector2.ZERO, friction*delta)
	if floorRay.is_colliding(): vel.y -= 100 * delta

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


func _on_shoot_timer_timeout() -> void:
	targetPosition = select_position()
	state = State.Normal

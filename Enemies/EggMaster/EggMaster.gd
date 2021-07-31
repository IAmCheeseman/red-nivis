extends KinematicBody2D

enum {IDLE, WALK}

export var speed:int = 320
export var friction:float = 4
export var jumpForce:int = 640
export var trackSpeed:float = 4
export var walkRange = 16*5
export var cooldownTime = .2
export var maxGroupShots = 6
export var health = 50
export var damage = 6
export var bulletSpeed = 320

onready var gun = $Gun
onready var walkTimer = $WalkTimer
onready var scaleHelper = $ScaleHelper
onready var jumpRay = $ScaleHelper/Jumper
onready var gunY = $GunY
onready var anim = $AnimationPlayer
onready var hurtAnim = $Hurt
onready var playerDetection = $PlayerDetection
onready var cooldown = $Cooldown

var bullet = preload("res://Enemies/EnemyBullet/EnemyBullet.tscn")
var target:Node2D
var targetWalk:float
var groupShots = 0
var state = IDLE
var vel:Vector2 = Vector2.ZERO

signal dead


func _process(delta) -> void:
	vel.y += GameManager.gravity*delta
	match state:
		IDLE:
			idle_state(delta)
		WALK:
			walk_state(delta)
	if target:
		gun.look_at(target.global_position)
		gun.rotation_degrees = stepify(gun.rotation_degrees, 12)
	gun.scale.y = -1\
	if (gun.get_node("End").global_position-global_position).x < 0\
	else 1
	gun.position.x = scaleHelper.scale.x*8
	gun.position.y = gunY.position.y
	if !target: target = playerDetection.get_player()
	else:
		if global_position.distance_to(target.global_position) > get_viewport_rect().end.x*3:
			emit_signal("dead")
			queue_free()

	if cooldown.is_stopped(): shoot()

	vel.y = move_and_slide(vel).y


func idle_state(delta) -> void:
	anim.play("Idle")
	vel.x = lerp(vel.x, 0, friction*delta)

func walk_state(delta) -> void:
	anim.play("walk")
	vel.x = 1 if targetWalk > position.x else -1
	scaleHelper.scale.x = -vel.x
	vel.x *= speed*delta
	if global_position.distance_to(Vector2(targetWalk, global_position.y)) < 5:
		state = IDLE
		walkTimer.start(rand_range(1, 3.5))
	if jumpRay.is_colliding():
		vel.y = -jumpForce
		vel.x *= 4


func shoot():
	if !target: return

	var newBullet = bullet.instance()
	var dir = gun.global_position.direction_to(target.get_parent().global_position)
	newBullet.global_position = (dir*16)+gun.global_position
	newBullet.direction = dir
	newBullet.speed = bulletSpeed
	GameManager.spawnManager.spawn_object(newBullet)

	newBullet.hitbox.damage = damage
	groupShots += 1

	if groupShots == maxGroupShots:
		cooldown.start(cooldownTime*5)
		groupShots = 0
	else:
		cooldown.start(cooldownTime)


func _on_WalkTimer_timeout():
	state = WALK
	targetWalk = position.x+rand_range(-walkRange, walkRange)


func _on_hurt(edamage, _kbdir):
	health -= edamage
	hurtAnim.play("Hurt")
	if health <= 0:
		emit_signal("dead")
		queue_free()













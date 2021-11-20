extends KinematicBody2D

enum { TARGET, BOUNCE }

onready var anim = $AnimationPlayer
onready var sprite = $Sprite

onready var jumpTimer = $Timers/JumpTimer

onready var playerDetection = $Collisions/PlayerDetection
onready var floorRC = $Collisions/Floor

export var jumpForce:int = 400
export var speed:int = 80
export var accel:float = 4

var stick = preload("res://Entities/Enemies/Bosses/Gnome/Stick.tscn")

var vel := Vector2.ZERO
var target := 0

var player: Node2D

var state := TARGET

func _physics_process(delta: float) -> void:
	vel.y += Globals.GRAVITY*delta
	if !player:
		player = playerDetection.get_player()
		anim.play("Idle")
		get_target()
	else:
		match state: 
			TARGET:
				target_state(delta)
			BOUNCE:
				bounce_state(delta)
	
	vel.y = move_and_slide(vel).y


func target_state(delta: float) -> void:
	# Animation
	if floorRC.is_colliding():
		if is_equal_approx(vel.x, 0):
			anim.play("Idle")
		else:
			anim.play("Walk")
	else:
		anim.play("Falling")
	
	var targetV = -speed if target < global_position.x else speed
	sprite.scale.x = 1 if player.global_position.x < global_position.x else -1
	
	vel.x = lerp(vel.x, targetV, accel*delta)#*delta
	
	if global_position.distance_to(Vector2(target, global_position.y)) < 15:
		get_target()


func bounce_state(delta: float) -> void:
	pass


func get_target() -> void:
	if player:
		target = player.global_position.x + rand_range(-64, 64)


func _on_jump_timer_timeout() -> void:
	#if !floorRC.is_colliding(): return 
	vel.y = -jumpForce
	jumpTimer.start(rand_range(1, 2))
	instance_stick(vel)


func instance_stick(dir: Vector2) -> void:
	var newStick = stick.instance()
	newStick.dir = (dir.normalized()).rotated(
		deg2rad(rand_range(-24, 24))
		)*450
	newStick.global_position = global_position
	GameManager.spawnManager.spawn_object(newStick)


func _on_target_change_timer_timeout() -> void:
	get_target()

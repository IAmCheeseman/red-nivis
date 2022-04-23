extends KinematicBody2D

enum { IDLE, WALK, PUNCH_SIDE, UPPERCUT, LASER }

onready var playerDetection = $Collisions/PlayerDetection
onready var uppercutRay = $Collisions/UppercutRay
onready var floorRay = $Collisions/FloorRay

onready var sprite = $Sprite
onready var anim = $AnimationPlayer

onready var damageManager = $DamageManager

export var speed := 240.0
export var accel := 2.5
export var frict := 5.0
export var uppercutForce := 270.0

var vel: Vector2
onready var targetX := global_position.x

var player: Node2D
var state := WALK


func _process(delta: float) -> void:
	vel.y += Globals.GRAVITY * delta
	
	if !player:
		player = playerDetection.get_player()
		return
	
	match state:
		IDLE:
			idle_state(delta)
		WALK:
			walk_state(delta)
		PUNCH_SIDE:
			punch_side_state(delta)
		UPPERCUT:
			uppercut_state(delta)
		LASER:
			pass
	
	vel.y = move_and_slide(vel).y


func get_target_pos() -> void:
	if !player:
		targetX = global_position.x + rand_range(-64, 64)
	targetX = player.global_position.x


func jump(mod:=1.0) -> void:
	if floorRay.is_colliding():
		vel.y = -uppercutForce * mod


func uppercut(area: Area2D) -> void:
	if area.is_in_group("Player"):
		state = UPPERCUT
		jump()
		anim.stop()
		anim.play("PunchUp")


func dodge(area: Area2D) -> void:
	if area.is_in_group("PlayerBullet"):
		jump(1.5)


func _on_damaged() -> void:
	if damageManager.health < damageManager.maxHealth / 2:
		sprite.texture = preload("res://Entities/Enemies/Bosses/Fridgehead/Fridgehead_Hole.png")
		speed *= 1.25
		frict *= .75


func idle_state(delta: float) -> void:
	vel.x = lerp(vel.x, 0, frict * delta)
	
	anim.play("Idle")


func walk_state(delta: float) -> void:
	get_target_pos()
	var vectorTarget = Vector2(targetX, global_position.y)
	var dir := global_position.direction_to(vectorTarget).x
	
	vel.x = lerp(vel.x, dir * speed, accel * delta)
	
	sprite.flip_h = vel.x < 0
	
	anim.play("Run", -1, vel.x / speed)
	
	if global_position.distance_to(player.global_position) < 32:
		state = PUNCH_SIDE


func punch_side_state(delta: float) -> void:
	vel.x = lerp(vel.x, 0, frict * delta)
	anim.play("PunchSide")


func uppercut_state(delta: float) -> void:
	if floorRay.is_colliding():
		state = WALK


func laser_state(delta: float) -> void:
	pass


func _on_animation_finished(anim_name: String) -> void:
	match state:
		PUNCH_SIDE:
			if anim_name == "PunchSide":
				state = WALK
		UPPERCUT:
			if anim_name == "PunchUP":
				state = WALK









extends KinematicBody2D

enum { IDLE, WALK, PUNCH_SIDE, UPPERCUT, ATTACK }

onready var playerDetection = $Collisions/PlayerDetection
onready var floorRay = $Collisions/FloorRay
onready var uppercutHitbox = $Collisions/UppercutHitbox
onready var sidePunchHitbox = $Collisions/PunchSideHitbox

onready var sprite = $Sprite
onready var anim = $AnimationPlayer

onready var damageManager = $DamageManager

onready var attacks = $SpecialAttacks

export var speed := 240.0
export var accel := 2.5
export var frict := 5.0
export var uppercutForce := 270.0

var vel: Vector2
onready var targetX := global_position.x

var player: Node2D
var state := WALK
var headless := false

var currentAttack := Node2D


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
		ATTACK:
			currentAttack.attack(delta)
	
	vel.y = move_and_slide(vel).y


func get_target_pos() -> void:
	if !player:
		targetX = global_position.x + rand_range(-64, 64)
	targetX = player.global_position.x


func jump(mod:=1.0) -> void:
	if floorRay.is_colliding():
		vel.y = -uppercutForce * mod
		position.y -= abs(floorRay.cast_to.y)


func uppercut(area: Area2D) -> void:
	if area.is_in_group("player"):
		state = UPPERCUT
		jump()
		anim.stop()
		anim.play("PunchUp")


func dodge(area: Area2D) -> void:
	if area.is_in_group("PlayerBullet"):
		jump(1.5)


func attack() -> void:
	var amt = attacks.get_child_count()
	for i in amt:
		var c = attacks.get_child(rand_range(0, amt))
		if c.test():
			state = ATTACK
			currentAttack = c


func _on_damaged() -> void:
	if damageManager.health <= damageManager.maxHealth / 2 and !headless:
		sprite.texture = preload("res://Entities/Enemies/Bosses/Fridgehead/Fridgehead_Hole.png")
		headless = true
		
		var fridge = preload("res://Entities/Enemies/Bosses/Fridgehead/FridgeFly.tscn").instance()
		fridge.global_position = global_position - Vector2(0, 45)
#		fridge.player = player
		GameManager.spawnManager.spawn_object(fridge)
	
	if state == UPPERCUT: state = WALK


func _on_dead() -> void:
	var fridge = preload("res://Entities/Enemies/Bosses/Fridgehead/Fridge.tscn").instance()
	fridge.global_position = global_position - Vector2(0, 100)
	fridge.player = player
	GameManager.spawnManager.spawn_object(fridge)


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
	vel.x = lerp(vel.x, 0, frict * delta)
	if floorRay.is_colliding():
		uppercutHitbox.get_child(0).disabled = true
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















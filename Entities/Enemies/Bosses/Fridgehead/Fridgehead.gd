extends KinematicBody2D

enum { IDLE, WALK, PUNCH_SIDE, UPPERCUT, BLOCK, ATTACK }

onready var playerDetection = $Collisions/PlayerDetection
onready var floorRay = $Collisions/FloorRay
onready var wallRay = $Collisions/WallRay
onready var uppercutHitbox = $Collisions/UppercutHitbox
onready var sidePunchHitbox = $Collisions/PunchSideHitbox
onready var blockHitbox = $Collisions/BlockHitbox/CollisionShape2D

onready var sprite = $Sprite
onready var anim = $AnimationPlayer

onready var damageManager = $DamageManager

onready var attacks = $SpecialAttacks

export var speed := 240.0
export var accel := 2.5
export var frict := 5.0
export var uppercutForce := 270.0
export(NodePath) onready var fridgePos = get_node(fridgePos)  

var vel: Vector2
onready var targetX := global_position.x

var player: Node2D
var state := WALK
var headless := false

var currentAttack := Node2D

var fridge: Node2D


func _ready() -> void:
	var jumpState = $SpecialAttacks/Jump
	jumpState.endPos = fridgePos.global_position


func _process(delta: float) -> void:
	vel.y += Globals.GRAVITY * delta
	
	if !player:
		player = playerDetection.get_player()
		anim.play("Idle")
	else:
		blockHitbox.disabled = true
		match state:
			IDLE:
				idle_state(delta)
			WALK:
				walk_state(delta)
			PUNCH_SIDE:
				punch_side_state(delta)
			UPPERCUT:
				uppercut_state(delta)
			BLOCK:
				block_state(delta)
			ATTACK:
				currentAttack.attack(delta)
			-1:
				vel = Vector2.DOWN * 1000
				anim.play("Idle")
				if global_position.distance_to(fridge.global_position) < 32:
					GameManager.emit_signal("screenshake", 10, 8, .05, .1)
					queue_free()
	
	sprite.rotation_degrees = vel.x / 25
	
	vel.y = move_and_slide(vel).y


func get_target_pos() -> void:
	if !player:
		targetX = global_position.x + rand_range(-64, 64)
	targetX = player.global_position.x


func jump(mod:=1.0) -> void:
	if floorRay.is_colliding() or state == ATTACK and !state in [BLOCK, ATTACK]:
		vel.y = -uppercutForce * mod
		position.y -= abs(floorRay.cast_to.y)


func uppercut(area: Area2D) -> void:
	if area.is_in_group("player") and !state in [BLOCK, ATTACK]:
		state = UPPERCUT
		jump()
		anim.stop()
		anim.play("PunchUp")


func dodge(area: Area2D) -> void:
	if state == BLOCK: return
	if area.is_in_group("PlayerBullet"):
		if !state in [UPPERCUT, ATTACK] and Utils.coin_flip():
			state = PUNCH_SIDE
			yield(TempTimer.timer(self, .05), "timeout")
			if is_instance_valid(area): area.get_parent().queue_free()
		else:
			state = WALK
			jump()


func attack() -> void:
	if state == -1 or !player: return
	
	var amt = attacks.get_child_count()
	if rand_range(0, amt + 1) > 1 and !headless:
		state = BLOCK
		targetX = to_local(player.global_position).x * 1000
		return
	
	for i in amt:
		var c = attacks.get_child(rand_range(0, amt))
		if c.test():
			state = ATTACK
			currentAttack = c
			return


func _on_damaged() -> void:
	if damageManager.health <= damageManager.maxHealth / 2 and !headless:
		sprite.texture = preload("res://Entities/Enemies/Bosses/Fridgehead/Fridgehead_Hole.png")
		headless = true
		
		fridge = preload("res://Entities/Enemies/Bosses/Fridgehead/FridgeFly.tscn").instance()
		fridge.targetPos = fridgePos.global_position
		fridge.global_position = global_position - Vector2(0, 45)
		GameManager.spawnManager.spawn_object(fridge)
	
	if state == UPPERCUT: state = WALK


func _on_dead() -> void:
	GameManager.emit_signal("zoom_in", .75, 3, .1, floorRay.get_collision_point())
	state = -1
	
	yield(TempTimer.timer(self, 2), "timeout")
	fridge.queue_free()
	
	fridge = preload("res://Entities/Enemies/Bosses/Fridgehead/Fridge.tscn").instance()
	fridge.global_position = global_position - Vector2(0, 100)
	fridge.player = player
	GameManager.spawnManager.spawn_object(fridge)
	
	yield(TempTimer.timer(self, 1), "timeout")
	queue_free()


func idle_state(delta: float) -> void:
	vel.x = lerp(vel.x, 0, frict * delta)
	
	anim.play("Idle")


func walk_state(delta: float) -> void:
	get_target_pos()
	var vectorTarget = Vector2(targetX, global_position.y)
	var dir := global_position.direction_to(vectorTarget).x
	
	var actualAccel = accel if floorRay.is_colliding() else 0
	vel.x = lerp(vel.x, dir * speed, actualAccel * delta)
	
	sprite.flip_h = vel.x < 0
	
	anim.play("Run", -1, vel.x / speed)
	
	if global_position.distance_to(player.global_position) < 32 and floorRay.is_colliding():
		state = PUNCH_SIDE


func block_state(delta: float) -> void:
	var vectorTarget = Vector2(targetX, global_position.y)
	var dir := global_position.direction_to(vectorTarget).x
	
	var actualAccel = accel if floorRay.is_colliding() else 0
	vel.x = lerp(vel.x, dir * (speed * 2), actualAccel * delta)
	
	wallRay.cast_to.x = dir * 16
	
	blockHitbox.disabled = false
	if wallRay.is_colliding():
		vel = Vector2(-vel.x / 2, -250)
		GameManager.emit_signal("screenshake", 3, 4, .05, .1)
		state = WALK
	
	sprite.flip_h = vel.x < 0
	
	anim.play("Block")


func punch_side_state(delta: float) -> void:
	vel.x = lerp(vel.x, 0, frict * delta)
	anim.play("PunchSide")


func uppercut_state(delta: float) -> void:
	vel.x = lerp(vel.x, 0, frict * delta)
	if floorRay.is_colliding():
		uppercutHitbox.get_child(0).disabled = true
		state = WALK


func _on_animation_finished(anim_name: String) -> void:
	match state:
		PUNCH_SIDE:
			if anim_name == "PunchSide":
				state = WALK
		UPPERCUT:
			if anim_name == "PunchUP":
				state = WALK















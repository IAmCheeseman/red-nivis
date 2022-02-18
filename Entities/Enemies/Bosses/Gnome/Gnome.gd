extends KinematicBody2D

enum { TARGET, SWIPE, BOUNCE, ASCEND, DEAD }

onready var anim = $AnimationPlayer
onready var sprite = $Sprite

onready var jumpTimer = $Timers/JumpTimer
onready var attacktimer = $Timers/AttackTimer
onready var bounceTimer = $Timers/BounceTimer
onready var ascendTimer = $Timers/AscendTimer

onready var playerDetection = $Collisions/PlayerDetection
onready var floorRC = $Collisions/Floor
onready var bounceHB = $Collisions/BounceHitbox
onready var bounceRC = $Collisions/Bounce

onready var dialog = $Dialog

export var jumpForce := 400
export var speed := 80
export var accel := 4
export var defaultStickAmount := Vector2(1, 2)

var stick := preload("res://Entities/Enemies/Bosses/Gnome/Stick.tscn")

var vel := Vector2.ZERO
var target := 0
var deathStick: Node2D

var firstTime := true

var player: Node2D

var state := TARGET



func _physics_process(delta: float) -> void:
	vel.y += Globals.GRAVITY*delta
	position_dialog()
	if !player:
		player = playerDetection.get_player()
		anim.play("Idle")
		get_target()
		# Animating
		if floorRC.is_colliding():
			anim.play("Idle")
		else:
			anim.play("Falling")
	else:
		if firstTime:
			firstTime = false
			dialog.show()
			dialog.start_dialog()
		match state: 
			TARGET:
				target_state(delta)
			BOUNCE:
				bounce_state()
			SWIPE:
				anim.play("Attack")
			ASCEND:
				ascend_state(delta)
			DEAD:
				vel = Vector2.ZERO
				anim.play("Die")
	
	if vel.x > 300:
		vel.x = 300
	if abs(vel.y) > Globals.GRAVITY:
		vel.y = (vel.y/vel.y) * Globals.GRAVITY
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


func bounce_state() -> void:
	anim.play("Falling")
	bounceHB.get_node("CollisionShape2D").disabled = false
	bounceRC.enabled = bounceTimer.is_stopped()
	bounceRC.cast_to = vel.normalized()*16
	bounceRC.force_raycast_update()
	if bounceRC.is_colliding():
		var normal = bounceRC.get_collision_normal()
		if bounceRC.cast_to.y > 0:
			state = TARGET
			bounceHB.get_node("CollisionShape2D").disabled = false
			return
		vel = vel.bounce(normal)*.9
		vel = vel.rotated(to_local(player.global_position).angle()/5)


func ascend_state(_delta: float) -> void:
	anim.play("Acsend")
	target = int(player.global_position.x)
	vel = global_position.direction_to(
		Vector2(target, player.global_position.y - 100)
	) * speed


func get_target() -> void:
	if player:
		target = int(player.global_position.x + rand_range(-64, 64))


func _on_jump_timer_timeout() -> void:
	if state in [BOUNCE, ASCEND, DEAD]: return 
	vel.y = -jumpForce
	jumpTimer.start(rand_range(1.5, 2))
	instance_stick(vel)


func _on_attack_timer_timeout() -> void:
	if state == DEAD: return
	if state == TARGET and floorRC.is_colliding(): 
		state = SWIPE
	attacktimer.start(1)


func instance_stick(dir: Vector2, amt: Vector2=defaultStickAmount) -> void:
	for i in rand_range(amt.x, amt.y):
		var newStick = stick.instance()
		newStick.direction = (dir.normalized()).rotated(
			deg2rad(rand_range(-24, 24))
			)*350
		newStick.global_position = global_position
		GameManager.spawnManager.spawn_object(newStick)


func _on_target_change_timer_timeout() -> void:
	get_target()


func _on_animation_finished(anim_name: String) -> void:
	if state == DEAD: return
	if anim_name == "Attack":
		state = TARGET


func swipe() -> void:
	var newSwipe = preload(\
		"res://Entities/Enemies/Bosses/Gnome/GnomeSwing.tscn"\
	).instance()
	var pos = global_position
	pos.y -= 8
	newSwipe.global_position = pos
	newSwipe.player = player
	GameManager.spawnManager.spawn_object(newSwipe)
	yield(get_tree(), "idle_frame")
	newSwipe.look_at(pos+(Vector2.LEFT*sprite.scale.x))
	newSwipe.global_position += Vector2.RIGHT.rotated(newSwipe.rotation)*10


func _on_hurt(_amount, _dir) -> void:
	if state == DEAD: return
	state = BOUNCE
	vel.y = -200
	position.y -= 8
	bounceTimer.start()
	ascendTimer.start()
	if anim.current_animation != "Falling": instance_stick(vel)
	
	if dialog.currentDialogID == "" and rand_range(0, 1) < .15:
		dialog.show()
		dialog.start_dialog("Hit%s" % round(rand_range(1, 3)))


func _on_dead() -> void:
	if state == DEAD: return
	state = DEAD
	GameManager.emit_signal("zoom_in", .75, 7, .2, sprite.global_position - Vector2(0, 50))

func position_dialog() -> void:
	if sprite.scale.x == 1:
		dialog.rect_position = Vector2(6, -44)
	else:
		dialog.rect_position = Vector2(-6, -44)


func toggle_ascend() -> void:
	if state == DEAD: return
	if state != ASCEND:
		state = ASCEND
		dialog.start_dialog("Ascend%s" % ceil(rand_range(0, 2)))
	else:
		state = TARGET
	ascendTimer.start(2)


func _add_ascend_stick() -> void:
	if state != ASCEND: return
	instance_stick(Vector2.RIGHT.rotated(rand_range(0, PI * 2)), Vector2.ONE)


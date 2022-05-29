extends KinematicBody2D

enum { TARGET, DEAD, ASCEND }

onready var anim = $AnimationPlayer
onready var sprite = $Sprite

onready var jumpTimer = $Timers/JumpTimer

onready var playerDetection = $Collisions/PlayerDetection
onready var floorRC = $Collisions/Floor
onready var bounceHB = $Collisions/BounceHitbox
onready var bounceRC = $Collisions/Bounce

onready var dialog = $Dialog

onready var attacks = $Sprite/Attacks
onready var magicPortals = $MagicPortals

onready var damageManager = $DamageManager

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


var sticks := []


signal hurt


func _ready() -> void:
	magicPortals.gnome = self


func _physics_process(delta: float) -> void:
	vel.y += Globals.GRAVITY*delta
	position_dialog()
	if !player:
		player = playerDetection.get_player()
		for i in attacks.get_children() + [magicPortals]:
			i.player = player
		
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
			DEAD:
				vel = Vector2.ZERO
				anim.play("Die")
			ASCEND:
				vel.y = 0
				position.y = lerp(position.y, -75, 5 * delta)
				
				target_state(delta, "Acsend")

	if vel.x > 300:
		vel.x = 300
	if abs(vel.y) > Globals.GRAVITY:
		vel.y = (vel.y/vel.y) * Globals.GRAVITY
	vel.y = move_and_slide(vel).y


func target_state(delta: float, fallAnim:="Falling") -> void:
	# Animation
	if floorRC.is_colliding():
		if is_equal_approx(vel.x, 0):
			anim.play("Idle")
		else:
			anim.play("Walk")
	else:
		anim.play(fallAnim)

	var targetV = -speed if target < global_position.x else speed
	sprite.scale.x = 1 if player.global_position.x < global_position.x else -1

	vel.x = lerp(vel.x, targetV, accel*delta)#*delta

	if global_position.distance_to(Vector2(target, global_position.y)) < 15:
		get_target()


func get_target() -> void:
	if player:
		target = int(player.global_position.x + rand_range(-64, 64))


func _on_jump_timer_timeout() -> void:
	jumpTimer.start(rand_range(1.5, 2))
	
	if state in [DEAD] or !floorRC.is_colliding(): return
	vel.y = -jumpForce



func _on_hurt(_amount, _dir) -> void:
	if state == DEAD: return
	emit_signal("hurt")
	vel.y = -200
	position.y -= 8

	if dialog.currentDialogID == "" and rand_range(0, 1) < .15:
		dialog.show()
		dialog.start_dialog("Hit%s" % round(rand_range(1, 3)))
	
	if damageManager.health <= damageManager.maxHealth / 2:
		magicPortals.enabled = true


func _on_dead() -> void:
	if state == DEAD: return
	state = DEAD
	GameManager.emit_signal("zoom_in", .75, 7, .2, sprite.global_position - Vector2(0, 50))
	for i in sticks:
		if is_instance_valid(i):
			i.queue_free()


func position_dialog() -> void:
	if sprite.scale.x == 1:
		dialog.rect_position = Vector2(6, -22)
	else:
		dialog.rect_position = Vector2(-6, -22)


func attack() -> void:
	if !player or state in [DEAD]: return
	
	var children: Array = attacks.get_children()
	children.shuffle()
	
	for i in children:
		if i.test(self): return

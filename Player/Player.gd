extends KinematicBody2D

# Properties
export var maxSpeed := 80
export var accelaration := 5.0
export var friction := 3.0
export var recoveryTime = 1.0
export var tiltStrength = 5.0

# Nodes
onready var sprite = $ScaleHelper/Sprite
onready var shadow = $ScaleHelper/Sprite/Shadow
onready var scaleHelper = $ScaleHelper
onready var hurtbox = $Hurtbox
onready var healthVignette = $CanvasLayer/HealthThing
onready var vignette = $CanvasLayer/Vignette
onready var animationPlayer = $AnimationPlayer
onready var flashPlayer = $Flash
onready var deathScreen = $CanvasLayer/DeathScreen
onready var itemHolder = $ItemHolder
onready var backItemHolder = $ScaleHelper/Sprite/BackItemHolder
onready var camera = $Camera
onready var hurtTimer = $Hurtbox/HurtTimer
onready var healthBar = $HealthBar
onready var hurtSFX = $Sounds/Hurt

var healthVigIntens = 0
var vel := Vector2.ZERO
var lastFramePos = Vector2.ZERO


signal removeTile(mousePosition)


func _ready():
	# Making sure players cannot come back to life by leaving an area
	if GameManager.isDead:
		_on_death()
	if !Settings.vignette:
		vignette.queue_free()


func process_input(delta) -> Vector2:
	# INPUT
	# ------------------------------------------------
	var inputDir := Vector2.ZERO

	inputDir.x = Input.get_action_strength("move_right")-Input.get_action_strength("move_left")
	inputDir.y = Input.get_action_strength("move_down")-Input.get_action_strength("move_up")
	inputDir = inputDir.normalized()

	return inputDir*delta
	# ------------------------------------------------


func process_vel(dir, delta) -> void:
	var faceDir = get_global_mouse_position()-global_position
	sprite.scale.x = 1 if faceDir.x > 0 else -1

	# Setting velocity
	if dir.is_equal_approx(Vector2.ZERO):
		vel = vel.move_toward(Vector2.ZERO, friction*delta)
	else:
		vel = vel.move_toward(dir*maxSpeed, accelaration*delta)

	# Setting animations
	if vel.is_equal_approx(Vector2.ZERO):
		animationPlayer.play("Idle")
	else:
		animationPlayer.play("Run")


func _physics_process(delta):
	$CanvasLayer/Label.text = "FPS: %s" % Engine.get_frames_per_second()

	var inputDir = process_input(delta)
	process_vel(inputDir, delta)
	shadow.frame = sprite.frame

	healthVignette.material.set_shader_param("intensity", healthVigIntens)

	if backItemHolder.get_child_count() > 0:
		backItemHolder.get_child(0).scale = Vector2.ONE

	# Tilting the player in the direction they're moving
	sprite.rotation_degrees = vel.x*tiltStrength

# warning-ignore:return_value_discarded
	move_and_slide(vel*maxSpeed)

	# Fixing interia issue
	if lastFramePos.is_equal_approx(position):
		vel = Vector2.ZERO
	lastFramePos = position

	if hurtbox.health != 20.0 and hurtTimer.is_stopped():
		healthBar.value = GameManager.percentage_of(float(hurtbox.health), 20.0)
		healthBar.modulate.a = 1
		hurtbox.health += .01
		hurtbox.health = clamp(hurtbox.health, 0, 20.0)


func _input(event):
	if event.is_action_pressed("remove_tile"):
		emit_signal("removeTile", get_global_mouse_position())
# warning-ignore:return_value_discarded
	if Input.is_key_pressed(KEY_K): global_position = get_global_mouse_position()

	if event.is_action_pressed("swap_weapons")\
	and backItemHolder.get_child_count() == 1\
	and itemHolder.get_child_count() == 1:
		# Swapping weapons
		var held = itemHolder.get_child(0)
		var back = backItemHolder.get_child(0)

		# Front item
		itemHolder.remove_child(held)
		backItemHolder.add_child(held)
		held.set_logic(false)

		# Back item
		backItemHolder.remove_child(back)
		itemHolder.add_child(back)
		back.set_logic(true)


func _on_death():
	deathScreen.show()
	sprite.modulate.a = .5
	collision_mask = 0
	GameManager.isDead = true
	healthBar.value = 0
	healthBar.modulate.a = 1
	hurtbox.set_deferred("monitorable", false)
	hurtSFX.play()


func _on_Hurtbox_hurt():
	# Health flash
	var tween = $CanvasLayer/HealthThing/Tween
	tween.interpolate_property(self, "healthVigIntens", 0, .7, .2, Tween.TRANS_LINEAR)
	tween.start()

	# Feedback
	hurtSFX.play()
	flashPlayer.play("flash")

	# Healthbar
	healthBar.modulate.a = 1
	healthBar.value = GameManager.percentage_of(float(hurtbox.health), 20.0)
	hurtTimer.start(recoveryTime)


func _on_health_vig_tween_all_completed():
	# Resetting the health flash, so it goes away
	if hurtbox.health != 1 and is_equal_approx(healthVigIntens, .7):
		var tween = $CanvasLayer/HealthThing/Tween
		tween.interpolate_property(self, "healthVigIntens", .7, 0, .2, Tween.TRANS_LINEAR)
		tween.start()


func _on_Player_tree_entered():
	# Adding the items you picked up in the last scene
	if GameManager.heldItem:
		yield(get_tree(), "idle_frame")
		add_item()


func add_item(item = null):
	# Making sure you can't hold two items at once.
	if backItemHolder.get_child_count() == 0\
	and itemHolder.get_child_count() >= 1:
		var gun = itemHolder.get_child(0)
		itemHolder.remove_child(gun)
		backItemHolder.add_child(gun)
	elif backItemHolder.get_child_count() >= 1:
		itemHolder.get_child(0).queue_free()


	if item:
		GameManager.heldItemStats = item.stats
		item.queue_free()
	var newItem = load("res://Items/Weapons/Gun.tscn").instance()
	newItem.stats = GameManager.heldItemStats
	newItem.isPickedUp = true
	itemHolder.call_deferred("add_child", newItem)
	camera.maxOffset = camera.baseMaxOffset+GameManager.heldItemStats.look






extends KinematicBody2D

# Properties
export var maxSpeed := 80
export var accelaration := 5.0
export var terminalVel = 180
export var jumpForce = 360
export var gravity = 6.0
export var friction := 3.0
export var kbStrength = 45
export var recoveryTime = 1.0
export var tiltStrength = 5.0
export var inMenu = false

# Nodes
onready var sprite = $ScaleHelper/Sprite
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
onready var healthBar = $CanvasLayer/Bars/HealthBar/Bar
onready var ammoBar = $CanvasLayer/Bars/Ammobar/Bar
onready var inventory = $CanvasLayer/Inventory
onready var hurtSFX = $Sounds/Hurt
onready var floorChecker = $FloorChecker

var healthVigIntens = 0
var vel := Vector2.ZERO
var lastFramePos = Vector2.ZERO
var ammo = 100 setget set_ammo
var maxAmmo = 100
var walkParticles = preload("res://Player/WalkParticles.tscn")
var lockMovement = false


signal removeTile(mousePosition)
signal dropGun(gun, pos)


func _ready():
	ammo = ammo
	# Making sure players cannot come back to life by leaving an area
	if GameManager.isDead:
		_on_death()
	if !Settings.vignette:
		vignette.queue_free()
	inventory.visible = false
	healthBar.value = GameManager.percentage_of(float(hurtbox.health), 20.0)


func _physics_process(delta):
	$CanvasLayer/Label.text = "FPS: %s" % Engine.get_frames_per_second()

	if !lockMovement:
		# INPUT
		# ------------------------------------------------
		var moveDir := Vector2.ZERO

		moveDir.x = (Input.get_action_strength("move_right")-Input.get_action_strength("move_left")) * int(!inventory.visible)
		moveDir = moveDir.normalized()
		vel.x = lerp(vel.x, moveDir.x*maxSpeed, accelaration*delta)
		if !floorChecker.is_colliding():
			vel.y = lerp(vel.y, terminalVel, gravity*delta)
		elif vel.y > 0 and (floorChecker.get_collision_point()).distance_to(position)-1 < 2:
			vel.y = 0
		print((floorChecker.get_collision_point()).distance_to(position))

		var faceDir = get_global_mouse_position()-global_position
		sprite.scale.x = 1 if faceDir.x > 0 else -1
		sprite.rotation_degrees = vel.x/10

		# Setting animations
		if is_equal_approx(moveDir.x, 0):
			animationPlayer.play("Idle")
		else:
			animationPlayer.play("Run")

		move_and_slide(vel)
	else:
		sprite.rotation_degrees = 0
		animationPlayer.play("Idle")


	if hurtbox.health != 20.0 and hurtTimer.is_stopped():
		healthBar.value = GameManager.percentage_of(float(hurtbox.health), 20.0)
		hurtbox.health += .01
		hurtbox.health = clamp(hurtbox.health, 0, 20.0)


func _input(event):
	# Jumping
	if Input.is_action_just_pressed("swap_weapons") and floorChecker.is_colliding():
		vel.y = -jumpForce
	if Input.is_action_just_released("swap_weapons"):
		vel.y /= 1.5

	if event.is_action_pressed("remove_tile") and !inventory.visible:
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
		held.pivot.rotation = 0
		held.set_logic(false)
		GameManager.heldItems[1] = held.duplicate()

		# Back item
		backItemHolder.remove_child(back)
		itemHolder.add_child(back)
		back.set_logic(true)
		GameManager.heldItems[0] = back.duplicate()

		camera.maxOffset = camera.baseMaxOffset+back.look

	if Input.is_key_pressed(KEY_M):
		var newPlayer = load("res://Player/Player.tscn").instance()
		newPlayer.position = get_global_mouse_position()
		get_parent().add_child(newPlayer)



func add_walk_particles(spawnPos:Vector2):
	var newDust = walkParticles.instance()
	newDust.position = spawnPos

	# Making it look right
	var normalizedVelX = vel.normalized().x
	if normalizedVelX != 0: newDust.scale.x = -normalizedVelX
	else: newDust.rotation_degrees = 300

	newDust.emitting = true
	add_child(newDust)


func set_ammo(amount:int):
	ammo = amount
	ammoBar.value = GameManager.percentage_of(ammo, maxAmmo)


func _on_death():
	deathScreen.show()
	sprite.modulate.a = .5
	collision_mask = 0
	GameManager.isDead = true
	healthBar.value = 0
	healthBar.modulate.a = 1
	hurtbox.set_deferred("monitorable", false)
	hurtSFX.play()


func _on_Hurtbox_hurt(dir):
	# Health flash
	var tween = $CanvasLayer/HealthThing/Tween
	tween.interpolate_property(self, "healthVigIntens", 0, .7, .2, Tween.TRANS_LINEAR)
	tween.start()

	# Feedback
	hurtSFX.play()
	flashPlayer.play("flash")

	# Healthbar
	healthBar.value = GameManager.percentage_of(float(hurtbox.health), 20.0)
	hurtTimer.start(recoveryTime)

	GameManager.emit_signal("screenshake", 2, 8, .05, .05, 9)

	dir += dir*kbStrength


func _on_health_vig_tween_all_completed():
	# Resetting the health flash, so it goes away
	if hurtbox.health != 1 and is_equal_approx(healthVigIntens, .7):
		var tween = $CanvasLayer/HealthThing/Tween
		tween.interpolate_property(self, "healthVigIntens", .7, 0, .2, Tween.TRANS_LINEAR)
		tween.start()


func _on_Player_tree_entered():
	if inMenu:
		return
	yield(get_tree(), "idle_frame")
	# Adding the items you picked up in the last scene
	# Adding back weapon
	if GameManager.heldItems[1] != null and backItemHolder.get_child_count() == 0:
		var weapon = add_item(GameManager.heldItems[1], backItemHolder)
		yield(get_tree(), "idle_frame")
		weapon.set_logic(false)
	# Adding held weapon
	if GameManager.heldItems[0] != null and itemHolder.get_child_count() == 0:
		add_item(GameManager.heldItems[0], itemHolder)


func gunShot(dir, recoil, cost):
	vel += -dir*recoil
	ammo -= cost


func add_item(item=null, addTo=null):
	# Making sure you can't hold two items at once.
	if backItemHolder.get_child_count() == 0\
	and itemHolder.get_child_count() > 0:
		# Moving the current held item to your back if no back item
		var gun = itemHolder.get_child(0)
		itemHolder.remove_child(gun)
		backItemHolder.add_child(gun)
		GameManager.heldItems[1] = gun
		gun.set_logic(false)

	elif backItemHolder.get_child_count() > 0 and itemHolder.get_child_count() > 0:
		# removing the current held item if there is a back item
		var gun = itemHolder.get_child(0)
		itemHolder.remove_child(gun)
		if item:
			emit_signal("dropGun", gun, item.position)

	if backItemHolder.get_child_count() > 0:
		backItemHolder.get_child(0).set_logic(false)

	# Adding the gun to your saved guns
	if item and !item in GameManager.heldItems:
		item.position = Vector2.ZERO
		item.isPickedUp = true
		item.rotation = 0
		item.set_logic(true)
		GameManager.heldItems[0] = item
		item.get_parent().remove_child(item)

	# Adding item to game world
	var newItem = item.duplicate()
	newItem.isPickedUp = true
	if !addTo:
		itemHolder.call_deferred("add_child", newItem)
	else:
		if addTo.get_child_count() > 0:
			addTo.get_child(0).queue_free()
		addTo.call_deferred("add_child", newItem)

	# Setting up the item
	newItem.connect("onShoot", self, "gunShot")
	newItem.player = self

	camera.maxOffset = camera.baseMaxOffset+newItem.look
	return newItem






extends KinematicBody2D

enum states {WALK, DEAD, WALLSLIDE, DASH}

const averageTileSize = 16
const SNAP_DIRECTION = Vector2.DOWN
const SNAP_LENGTH = 5

# Nodes
onready var sprite := $ScaleHelper/Sprite
onready var hand := $ScaleHelper/Sprite/Arm
onready var rightHand := $ScaleHelper/Sprite/Arm/Hand
onready var collision := $CollisionShape2D
onready var scaleHelper := $ScaleHelper
onready var hurtbox := $Hurtbox
onready var vignette := $CanvasLayer/Vignette
onready var grayscale := $CanvasLayer/GrayScaleDeath
onready var animationPlayer := $AnimationPlayer
onready var SaS := $SquashAndStretch
onready var flashPlayer := $Flash
onready var deathScreen := $CanvasLayer/GameOver
onready var itemHolder := $ItemHolder
onready var inventory := $CanvasLayer/Inventory
onready var hurtSFX := $Sounds/HurtSFX
onready var jumpSFX := $Sounds/JumpSFX
onready var walkSFX := $Sounds/WalkSFX
onready var dropDownTimer := $DropDownTimer
onready var jumpWindow := $APressWindow
onready var dashCooldown := $DashCooldown
onready var healthVig := $CanvasLayer/HealthVig
onready var healVignette := $CanvasLayer/HealVig
onready var gameOverlay := $CanvasLayer/GameOverlay
onready var tileChecker := $TileCheckers/BottomTileChecker
onready var djParticles := $DoubleJumpParticles
onready var passives = $Passives

var vel := Vector2.ZERO
var snapVector := SNAP_DIRECTION*SNAP_LENGTH
var lastFrameGroundState := false
var triedJumpRecent := false
var mouseTarget := Vector2.ZERO
var lastUsedMouse := true
var state = states.WALK
var dontPlayJump := false

var lastUpdatedAim := Vector2.RIGHT*64

var walkParticles := preload("res://Entities/Player//WalkParticles.tscn")
var landParticles := preload("res://Entities/Player/Assets/LandParticles.tscn")
var playerData := preload("res://Entities/Player/Player.tres")
var lockMovement := false
var timeOnGround := 0.0

var gravity := 0.0
var controllerPressed = 0.0


signal just_landed
signal jumped


func _ready():
	update_passives()
	GameManager.player = self
	var date = OS.get_date()
	if date.month == OS.MONTH_DECEMBER and date.day <= 25:
		sprite.texture = load("res://Entities/Player/Assets/player_sheet_xmas.png")
	# Making sure players cannot come back to life by leaving an area
	if playerData.isDead:
		die()
	playerData.playerObject = self
	grayscale.material.set_shader_param("strength", 1)
	var _discard1 = playerData.connect("healthChanged", self, "_on_health_changed")
	var _discard2 = hurtbox.connect("hurt", playerData, "_on_damage_taken")

# warning-ignore:incompatible_ternary
	gravity = Globals.GRAVITY * scale.x if !GameManager.underwater else Globals.WATER_GRAVITY

func _physics_process(delta: float) -> void:
	healthVig.modulate.a = lerp(healthVig.modulate.a, 0, 5.0*delta)
	healVignette.modulate.a = lerp(healVignette.modulate.a, 0, 1.25*delta)
	
	# Controller stuff
	if !GameManager.usingController: for i in 16:
		if Input.is_joy_button_pressed(0, i):
			controllerPressed += delta
			if controllerPressed >= 1:
				GameManager.usingController = true
				controllerPressed = 0
	else: for i in 16:
		if Input.is_action_pressed("use_item"):
			controllerPressed += delta
			if controllerPressed >= 1:
				GameManager.usingController = false
				controllerPressed = 0

	match state:
		states.WALK:
			walk_state(delta)
		states.DEAD:
			if just_landed():
				animationPlayer.play("Dead")
			if is_grounded():
				vel.x = lerp(
					vel.x,
					0,
					playerData.accelaration*delta
				)
				if vel.y < 0: vel.y += gravity*delta
				else: vel.y += (gravity * playerData.downGravMod)*delta
			vel.y = move_and_slide_with_snap(vel, snapVector, Vector2.UP, true, 4, deg2rad(45)).y
			Engine.time_scale = lerp(Engine.time_scale, .2, 5*delta)

			var grayscaleStrength = grayscale.material.get_shader_param("strength")
			grayscale.material.set_shader_param("strength", lerp(grayscaleStrength, .15, 2*delta))
		states.WALLSLIDE:
			walk_state(delta)
			sprite.scale.x = -tileChecker.cast_to.normalized().x
			vel.y /= 1.75
		states.DASH:
			SaS.play("Dash")
			vel.y = move_and_slide_with_snap(vel, snapVector, Vector2.UP, true, 4, deg2rad(45)).y
			scaleHelper.scale = scaleHelper.scale.move_toward(Vector2.ONE, 5*delta)
	
	if just_landed(): emit_signal("just_landed")
	
	controller_aiming()
	lastFrameGroundState = is_grounded()


func walk_state(delta):
	if !lockMovement and !GameManager.inGUI:
		itemHolder.show()
		# INPUT
		# ------------------------------------------------
		var moveDir := Vector2.ZERO

		var postfix = "_c" if GameManager.usingController else ""
		moveDir.x = (Input.get_action_strength("move_right"+postfix)-\
					Input.get_action_strength("move_left"+postfix))
		moveDir = moveDir.normalized() * scale.x
		var speed
		var accel
		if is_grounded():
			timeOnGround += delta
			speed = playerData.maxSpeed
			accel = playerData.accelaration * playerData.accelMod\
				if abs(moveDir.x * speed) > vel.x\
				else playerData.friction * playerData.frictMod
		else:
			speed = playerData.maxAirSpeed
			accel = playerData.airAccel * playerData.accelMod

		if moveDir.x == 0:
			accel = playerData.friction * playerData.frictMod
		vel.x = lerp(
			vel.x,
			moveDir.x*(speed * playerData.speedMod),
			accel*delta
		)
		sprite.rotation_degrees = vel.x / 25
		# Do stuff in the air.
		if vel.y < 0: vel.y += gravity * delta
		else:         vel.y += (gravity * playerData.downGravMod) * delta

		var faceDir = Utils.get_local_mouse_position(self)
		sprite.scale.x = 1 if faceDir.x > 0 else -1

		animate(moveDir)

		if just_landed():
			if dashCooldown.is_stopped(): playerData.dashesLeft = playerData.maxDashes
	else:
		itemHolder.hide()
		
		if vel.y < 0: vel.y += gravity * delta
		else:         vel.y += (gravity * 5) * delta
		vel.x = lerp(
			vel.x,
			0,
			playerData.friction*delta
		)
		sprite.rotation_degrees = vel.x / 25
		animate(Vector2.ZERO)
		
		hand.show()
		rightHand.show()
	vel.y = move_and_slide_with_snap(vel, snapVector, Vector2.UP, true, 4, deg2rad(45)).y


func animate(moveDir:Vector2):
	if playerData.isDead:
		return
	if flashPlayer.is_playing():
		animationPlayer.stop()
		return
	if animationPlayer.current_animation == "DoubleJump":
		dontPlayJump = true

	if itemHolder.get_child_count() > 0:
		hand.visible = !itemHolder.get_child(0).isTwoHanded and state != states.WALLSLIDE
		rightHand.hide()
	else:
		rightHand.show()
	if is_grounded():
		if is_equal_approx(moveDir.x, 0):
			sprite.rotation_degrees = 0
			animationPlayer.play("Idle")
		else:
			animationPlayer.play("Run", -1, clamp(abs(vel.x)/110, .7, INF))
	else:
		if !dontPlayJump:
			animationPlayer.play("Jump")
	if state == states.WALLSLIDE:
		dontPlayJump = false
		animationPlayer.play("WallSlide")


func just_landed():
	if is_grounded() != lastFrameGroundState and lastFrameGroundState == false:
		if vel.y > 0 and !lockMovement:
			var newParticles = landParticles.instance()
			newParticles.position = global_position
			newParticles.emitting = true
			GameManager.spawnManager.spawn_object(newParticles)
			SaS.play("Land")
		dontPlayJump = false
		timeOnGround = 0
		if triedJumpRecent:
			jump()
			triedJumpRecent = false
		return true
	return false


func is_grounded():
	if $FloorChecker.get_overlapping_bodies().size() != 0:
		snapVector = SNAP_DIRECTION*SNAP_LENGTH if !Input.is_action_just_pressed("jump")\
		else Vector2.ZERO
		return true

	if vel.y > 0 and state != states.DASH and !lockMovement:
		scaleHelper.scale.x = clamp(
			1-abs(vel.y/Globals.GRAVITY),
			.75, 1.5)
		scaleHelper.scale.y = 1+(1-scaleHelper.scale.x)
	return false


func controller_aiming() -> void:
	if !GameManager.usingController: return

	var joystickVector = Vector2(
		Input.get_joy_axis(0, JOY_ANALOG_RX),
		Input.get_joy_axis(0, JOY_ANALOG_RY)
	).normalized() * 128
	joystickVector = lastUpdatedAim if joystickVector == Vector2.ZERO else joystickVector
	lastUpdatedAim = joystickVector

	joystickVector += Utils.get_relative_to_camera(itemHolder, GameManager.currentCamera)
	Input.warp_mouse_position(joystickVector)


func _input(_event: InputEvent) -> void:
	if playerData.isDead:
		return
	# Jumping
	if Input.is_action_just_pressed("jump") and !lockMovement:
		triedJumpRecent = true
		jumpWindow.start()
		if is_grounded() or state == states.WALLSLIDE:
			jump()
	# Adjustable jump height
	if Input.is_action_just_released("jump") and vel.y < 0:# and !is_grounded():
		vel.y *= 0.5

	if Input.is_action_just_pressed("down") and !lockMovement:
		set_collision_mask_bit(4, false)
		dropDownTimer.start(.1)

# warning-ignore:return_value_discarded
	if Input.is_key_pressed(KEY_K):
		GameManager.global_position = Utils.get_global_mouse_position()


func _on_dash_cooldown_timeout():
	state = states.WALK
	vel *= 0.25
	if is_grounded(): playerData.dashesLeft = playerData.maxDashes


func add_walk_particles(spawnPos:Vector2):
	var newDust = walkParticles.instance()
	newDust.position = spawnPos

	# Making it look right
	var normalizedVelX = vel.normalized().x
	if normalizedVelX != 0: newDust.scale.x = -normalizedVelX
	newDust.emitting = true

	add_child(newDust)


func jump():
	if GameManager.inGUI: return
	# Setting values
	jumpSFX.play()
	#snapVector = Vector2.ZERO
	vel.y = -playerData.jumpForce * scale.x
	if timeOnGround <= 0.05:
		vel.x *= 1.8
	elif timeOnGround <= 0.1:
		vel.x *= 1.25
	elif timeOnGround <= .2:
		vel.x *= 1.1

	if GameManager.underwater:
		vel.y /= 1.75

	triedJumpRecent = false
	
	emit_signal("jumped")


func _on_a_press_window_timeout(): triedJumpRecent = false


func die():
	Achievement.unlock("DEATH")
	playerData.deaths += 1
	if playerData.deaths >= 100: Achievement.unlock("100_DEATHS")

	GameManager.clear_run()
	GameManager.inGUI = true
	state = states.DEAD
	playerData.isDead = true
	hurtbox.set_deferred("monitorable", false)
	animationPlayer.play("Die")

	var defTimah = Timer.new()
	defTimah.connect("timeout", self, "show_death_screen", [defTimah])
	add_child(defTimah)
	defTimah.start(.4)

	for i in itemHolder.get_children():
		i.queue_free()
	itemHolder.hide()


func show_death_screen(timer:Timer) -> void:
	deathScreen.update_stats()
	deathScreen.show()
	if animationPlayer.current_animation != "Dead": animationPlayer.play("Dead")
	timer.queue_free()


func _on_health_changed(dir: Vector2) -> void:
	if playerData.godmode:
		playerData.health = playerData.maxHealth
		return
	# Feedback
	if !dashCooldown.is_stopped():
		return
	GameManager.frameFreezer.freeze_frames(.2)
	healthVig.modulate.a = 1

	hurtSFX.play()
	flashPlayer.play("flash")
	if playerData.health <= 0:
		vel = dir*(playerData.kbStrength*1.5)
		die()
		return
	# Screenshake
	GameManager.emit_signal("screenshake", 2, 6, .05, .05)

	# Knockback
	dir = dir*playerData.kbStrength
	vel = dir


func update_passives() -> void:
	Utils.free_children(passives)
	
	for i in playerData.passives:
		var item = load(i.item)
		if item.applyOnce and i.used:
			continue
		var used = i.used
		i.used = true
		
		var newPassive = item.scene.instance()
		newPassive.set_meta("used", used)
		passives.add_child(newPassive)
	
	gameOverlay.update_ammo()
	gameOverlay.update_health(Vector2.ZERO)

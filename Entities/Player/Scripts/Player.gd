extends KinematicBody2D

enum states {WALK, DASH, DEAD}

const averageTileSize = 16
const SNAP_DIRECTION = Vector2.DOWN
const SNAP_LENGTH = 5

# Nodes
onready var sprite = $ScaleHelper/Sprite
onready var rightHand = $ScaleHelper/Sprite/Arm/Hand
onready var collision = $CollisionShape2D
onready var scaleHelper = $ScaleHelper
onready var hurtbox = $Hurtbox
onready var vignette = $CanvasLayer/Vignette
onready var animationPlayer = $AnimationPlayer
onready var SaS = $SquashAndStretch
onready var flashPlayer = $Flash
onready var deathScreen = $CanvasLayer/GameOverScreen
onready var itemHolder = $ItemHolder
onready var inventory = $CanvasLayer/Inventory
onready var hurtSFX = $Sounds/HurtSFX
onready var jumpSFX = $Sounds/JumpSFX
onready var walkSFX = $Sounds/WalkSFX
onready var floorCheckers = $FloorCheckers
onready var bottomTileChecker = $TileCheckers/BottomTileChecker
onready var topTileChecker = $TileCheckers/TopTileChecker
onready var bunnyHopTimer = $BunnyHopTimer
onready var jumpWindow = $APressWindow
onready var dashCooldown = $DashCooldown
onready var healthVig = $CanvasLayer/HealthVig
onready var gameOverlay = $CanvasLayer/GameOverlay

var vel := Vector2.ZERO
var snapVector = SNAP_DIRECTION*SNAP_LENGTH
var lastFrameGroundState = false
var triedJumpRecent = false
var mouseTarget = Vector2.ZERO
var lastUsedMouse = true
var state = states.WALK


var walkParticles = preload("res://Entities/Player//WalkParticles.tscn")
var playerData = preload("res://Entities/Player/Player.tres")
var lockMovement = false


# warning-ignore:unused_signal
signal dropGun(gun, pos)


func _ready():
	# Making sure players cannot come back to life by leaving an area
	if playerData.isDead:
		die()
	if !Settings.vignette:
		vignette.queue_free()
	playerData.playerObject = self

	playerData.connect("healthChanged", self, "_on_health_changed")
	hurtbox.connect("hurt", playerData, "_on_damage_taken")


func _physics_process(delta):
	healthVig.modulate.a = lerp(healthVig.modulate.a, 0, 5.0*delta)
	playerData.isDashing = state == states.DASH
	
	match state:
		states.WALK:
			sprite.material.set_shader_param("is_on", 0)
			walk_state(delta)
		states.DASH:
			vel.y = round(vel.y)
			vel.y = move_and_slide_with_snap(vel, snapVector, Vector2.UP, true, 4, deg2rad(89)).y
			if test_move(transform, Vector2(vel.x, 0).normalized()): state = states.WALK
		states.DEAD:
			if just_landed():
				animationPlayer.play("Dead")
			if is_grounded():
				vel.x = lerp(
					vel.x,
					0,
					playerData.accelaration*delta
				)
			vel.y += GameManager.gravity*delta
			vel.y = move_and_slide_with_snap(vel, snapVector, Vector2.UP, true, 4, deg2rad(89)).y
			Engine.time_scale = lerp(Engine.time_scale, .2, 5*delta)


	lastFrameGroundState = is_grounded()


func walk_state(delta):
	if !lockMovement:
		# INPUT
		# ------------------------------------------------
		var moveDir := Vector2.ZERO

		moveDir.x = (Input.get_action_strength("move_right")-Input.get_action_strength("move_left"))
		moveDir = moveDir.normalized()
		vel.x = lerp(
			vel.x,
			moveDir.x*(playerData.maxSpeed*( 1+(playerData.jumpSpeedMod*int(!is_grounded())) ) ),
			playerData.accelaration*delta
		)
		# Do stuff in the air.
		vel.y += Globals.GRAVITY*delta

		var faceDir = get_local_mouse_position()
		sprite.scale.x = 1 if faceDir.x > 0 else -1

		animate(moveDir)

		if just_landed():
			if dashCooldown.is_stopped(): playerData.dashesLeft = playerData.maxDashes
			bunnyHopTimer.start()
		
		set_collision_mask_bit(4, !Input.is_action_pressed("down"))
		
		vel.y = move_and_slide_with_snap(vel, snapVector, Vector2.UP, true, 4, deg2rad(89)).y
	else:
		sprite.rotation_degrees = 0
		animationPlayer.play("Idle")


func animate(moveDir:Vector2):
	if playerData.isDead:
		return
	var noHand = ""
	if itemHolder.get_child_count() > 0:
		noHand = "NoHand" if itemHolder.get_child(0).stats.isTwoHanded else ""
		rightHand.hide()
	else:
		rightHand.show()
	if is_grounded():
		if is_equal_approx(moveDir.x, 0) or test_move(transform, Vector2(vel.normalized().x, 0)):
			sprite.rotation_degrees = 0
			animationPlayer.play("Idle%s" % noHand)
		else:
			animationPlayer.play("Run%s" % noHand)
	else:
		animationPlayer.play("Jump%s" % noHand)


func just_landed():
	if is_grounded() != lastFrameGroundState and lastFrameGroundState == false:
		if vel.y > -playerData.jumpForce*0.15: SaS.play("Land")
		if triedJumpRecent:
			jump()
			bunnyHopTimer.start()
			bunny_hop()
			triedJumpRecent = false
		return true
	return false

func is_grounded():
	for c in floorCheckers.get_children():
		if c.is_colliding():
			snapVector = SNAP_DIRECTION*SNAP_LENGTH if !Input.is_action_just_pressed("jump") else Vector2.ZERO
			return true
	return false

func is_on_platform():
	for c in floorCheckers.get_children():
		if c.is_colliding():
			if c.get_collider().is_in_group("Platform"):
				return true
	return false


func _input(event):
	if playerData.isDead:
		return
	# Jumping
	if Input.is_action_just_pressed("jump"):
		triedJumpRecent = true
		jumpWindow.start()
		if is_grounded():
			jump()
	# Adjustable jump height
	if Input.is_action_just_released("jump") and vel.y < 0 and !is_grounded():
		vel.y *= 0.5
	
	

	# Controller Controls
	# Aiming
	if event is InputEventJoypadMotion:
		var joystickVector = Vector2(Input.get_joy_axis(0, JOY_ANALOG_RX),
		Input.get_joy_axis(0, JOY_ANALOG_RY)).normalized()*128
		if joystickVector.length() < 64:
			return
		mouseTarget = joystickVector#+(OS.window_size/2)
		mouseTarget += Utils.get_relative_to_camera(self, $Camera)
		Input.warp_mouse_position(mouseTarget)



# warning-ignore:return_value_discarded
	if Input.is_key_pressed(KEY_K):
		global_position = get_global_mouse_position()


func _on_dash_cooldown_timeout():
	state = states.WALK
	vel.x *= .1
	vel.y = Globals.GRAVITY*.25
	if is_grounded(): playerData.dashesLeft = playerData.maxDashes


func add_walk_particles(spawnPos:Vector2):
	var newDust = walkParticles.instance()
	newDust.position = spawnPos

	# Making it look right
	var normalizedVelX = vel.normalized().x
	if normalizedVelX != 0: newDust.scale.x = -normalizedVelX
	newDust.emitting = true

	add_child(newDust)

func bunny_hop(): if !bunnyHopTimer.is_stopped(): vel.x *= playerData.bunnyHopMult

func jump():
	# Setting values
	jumpSFX.play()
	snapVector = Vector2.ZERO
	vel.y = -playerData.jumpForce
	bunny_hop()
	triedJumpRecent = false
	# Squash and stretch
	SaS.play("Jump")


func _on_a_press_window_timeout(): triedJumpRecent = false

func die():
	state = states.DEAD
	playerData.isDead = true
	hurtbox.set_deferred("monitorable", false)
	animationPlayer.play("Die")
	
	var defTimah = Timer.new()
	defTimah.connect("timeout", self, "show_death_screen", [defTimah])
	add_child(defTimah)
	defTimah.start(.4)
	
	itemHolder.queue_free()

func show_death_screen(timer:Timer) -> void:
	deathScreen.show()
	timer.queue_free()

func _on_health_changed(dir):
	# Feedback
	if !dashCooldown.is_stopped():
		return
	GameManager.frameFreezer.freeze_frames(.2)
	healthVig.modulate.a = 1
	
	hurtSFX.play()
	flashPlayer.play("flash")
	if playerData.health <= 0:
		vel = dir*(playerData.kbStrength*1.2)
		die()
	# Screenshake
	GameManager.emit_signal("screenshake", 2, 6, .05, .05)
	# Knockback
	dir = dir*playerData.kbStrength



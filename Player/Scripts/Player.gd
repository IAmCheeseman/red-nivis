extends KinematicBody2D

const averageTileSize = 8
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
onready var deathScreen = $CanvasLayer/DeathScreen
onready var itemHolder = $ItemHolder
onready var camera = $Camera
onready var hurtTimer = $Hurtbox/HurtTimer
onready var healthBar = $CanvasLayer/Bars/HealthBar/Bar
onready var ammoBar = $CanvasLayer/Bars/Ammobar/Bar
onready var inventory = $CanvasLayer/Inventory
onready var hurtSFX = $Sounds/Hurt
onready var jumpSFX = $Sounds/JumpSFX
onready var walkSFX = $Sounds/WalkSFX
onready var floorCheckers = $FloorCheckers
onready var bottomTileChecker = $TileCheckers/BottomTileChecker
onready var topTileChecker = $TileCheckers/TopTileChecker
onready var bunnyHopTimer = $BunnyHopTimer
onready var jumpWindow = $APressWindow
onready var buildModeTimer = $BuildModeTimer
onready var buildModeNotifier = $CanvasLayer/BuildModeNotifier

var vel := Vector2.ZERO
var snapVector = SNAP_DIRECTION*SNAP_LENGTH
var lastFrameGroundState = false
var triedJumpRecent = false
var mouseTarget = Vector2.ZERO
var lastUsedMouse = true


var walkParticles = preload("res://Player/WalkParticles.tscn")
var playerData = preload("res://Player/Player.tres")
var lockMovement = false


signal removeTile(mousePosition)
# warning-ignore:unused_signal
signal dropGun(gun, pos)


func _ready():
	# Making sure players cannot come back to life by leaving an area
	if playerData.isDead:
		die()
	if !Settings.vignette:
		vignette.queue_free()
	healthBar.value = Utils.percentage_of(float(playerData.health), float(playerData.maxHealth))
	playerData.playerObject = self

	playerData.connect("ammoChanged", self, "_on_ammo_changed")
	playerData.connect("healthChanged", self, "_on_health_changed")
	hurtbox.connect("hurt", playerData, "_on_damage_taken")


func _physics_process(delta):
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
#		if !is_grounded():
		vel.y += GameManager.gravity*delta

		var faceDir = get_local_mouse_position()
		sprite.scale.x = 1 if faceDir.x > 0 else -1
		sprite.rotation_degrees = vel.x/15

		animate(moveDir)

		if just_landed():
			playerData.dashesLeft = playerData.maxDashes
			bunnyHopTimer.start()

		vel.y = move_and_slide_with_snap(vel, snapVector, Vector2.UP, true, 4, deg2rad(89)).y
	else:
		sprite.rotation_degrees = 0
		animationPlayer.play("Idle")

	lastFrameGroundState = is_grounded()


func animate(moveDir:Vector2):
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
		walkSFX.play(5)
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
	# Jumping
	if Input.is_action_just_pressed("jump"):
		triedJumpRecent = true
		jumpWindow.start()
		if is_grounded():
			jump()
	# Adjustable jump height
	if Input.is_action_just_released("jump") and vel.y < 0 and !is_grounded():
		vel.y *= 0.5
	
	collision.disabled = Input.is_action_pressed("down") and is_on_platform() and !test_move(transform, Vector2(vel.normalized().x, 0))
	
	# Dashing
	if Input.is_action_just_pressed("remove_tile") and playerData.dashesLeft > 0:
		var dashDir = Vector2.ZERO
		dashDir.x = Input.get_action_strength("move_right")-Input.get_action_strength("move_left")
		dashDir.y = Input.get_action_strength("down")-Input.get_action_strength("up")
		dashDir.normalized()
		dashDir *= playerData.dashSpeed
		
		dashDir.y = clamp(dashDir.y, -playerData.jumpForce, INF)
		
		if dashDir == Vector2.ZERO:
			return
		
		vel = dashDir
		playerData.dashesLeft -= 1
	
	# Destroying tiles and stuff :)
#	if event.is_action_pressed("remove_tile")\
#	or (playerData.mode == playerData.BUILD_MODE and event.is_action_pressed("use_item")):
#		emit_signal("removeTile", get_global_mouse_position())


	# Controller Controls

	# Build mode
	if event.is_action_pressed("build_mode"):
		playerData.mode = playerData.BUILD_MODE if\
		playerData.mode == playerData.DEFAULT_MODE else playerData.DEFAULT_MODE

	# Aiming
	if event is InputEventJoypadMotion:
		match playerData.mode:
			playerData.DEFAULT_MODE:
				var joystickVector = Vector2(Input.get_joy_axis(0, JOY_ANALOG_RX),
				Input.get_joy_axis(0, JOY_ANALOG_RY)).normalized()*128
				if joystickVector.length() < 64:
					return

				mouseTarget = joystickVector+(OS.window_size/2)
				mouseTarget.y += camera.yOffset

				Input.warp_mouse_position(mouseTarget)

			playerData.BUILD_MODE:
				if buildModeTimer.is_stopped():
					var moveVector = Vector2(Input.get_joy_axis(0, JOY_ANALOG_RX),
					Input.get_joy_axis(0, JOY_ANALOG_RY)).normalized()*16
					mouseTarget += moveVector

					Input.warp_mouse_position(mouseTarget)

					buildModeTimer.start()



# warning-ignore:return_value_discarded
	if Input.is_key_pressed(KEY_K):
		global_position = get_global_mouse_position()


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

func _on_ammo_changed(): ammoBar.value = Utils.percentage_of(playerData.ammo, playerData.maxAmmo)

func die():
	deathScreen.show()
	playerData.isDead = true
	hurtbox.set_deferred("monitorable", false)
	sprite.modulate.a = .5
	healthBar.value = 0


func _on_health_changed(dir):
	# Feedback
	hurtSFX.play()
	flashPlayer.play("flash")
	if playerData.health <= 0:
		die()
	# Healthbar
	healthBar.value = GameManager.percentage_of(float(playerData.health), float(playerData.maxHealth))
	hurtTimer.start(playerData.recoveryTime)
	# Screenshake
	GameManager.emit_signal("screenshake", 2, 6, .05, .05)
	# Knockback
	dir += dir*playerData.kbStrength

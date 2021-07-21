extends KinematicBody2D

const averageTileSize = 8
const SNAP_DIRECTION = Vector2.DOWN
const SNAP_LENGTH = 5

# Nodes
onready var sprite = $ScaleHelper/Sprite
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
onready var floorCheckers = $FloorCheckers
onready var bottomTileChecker = $TileCheckers/BottomTileChecker
onready var topTileChecker = $TileCheckers/TopTileChecker
onready var bunnyHopTimer = $BunnyHopTimer

var vel := Vector2.ZERO
var snapVector = SNAP_DIRECTION*SNAP_LENGTH
var lastFrameGroundState = false


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
	healthBar.value = GameManager.percentage_of(float(playerData.health), float(playerData.maxHealth))
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
		if !is_grounded():
			vel.y += GameManager.gravity*delta

		var faceDir = get_local_mouse_position()
		sprite.scale.x = 1 if faceDir.x > 0 else -1
		sprite.rotation_degrees = vel.x/15

		animate(moveDir)

		if just_landed():
			bunnyHopTimer.start()

		vel.y = move_and_slide_with_snap(vel, snapVector, Vector2.UP, true, 4, deg2rad(46)).y
	else:
		sprite.rotation_degrees = 0
		animationPlayer.play("Idle")

	lastFrameGroundState = is_grounded()


func animate(moveDir:Vector2):
	if is_grounded():
		if is_equal_approx(moveDir.x, 0):
				animationPlayer.play("Idle")
		else:
			animationPlayer.play("Run")
	else:
		animationPlayer.play("Jump")


func just_landed():
	if is_grounded() != lastFrameGroundState and lastFrameGroundState == false:
		if vel.y > 0: SaS.play("Land")
		return true
	return false
func is_grounded():
	for c in floorCheckers.get_children():
		if c.is_colliding():
			snapVector = SNAP_DIRECTION*SNAP_LENGTH if !Input.is_action_pressed("jump") else Vector2.ZERO
			return true
	return false


func _input(event):
	# Jumping
	if Input.is_action_just_pressed("jump") and is_grounded():
		# Setting values
		snapVector = Vector2.ZERO
		vel.y = -playerData.jumpForce
		if !bunnyHopTimer.is_stopped():
			vel.x *= playerData.bunnyHopMult
		# Squash and stretch
		SaS.play("Jump")
	# Adjustable jump height
	if Input.is_action_just_released("jump") and vel.y < 0 and !is_grounded():
		vel.y *= 0.5
	# Destroying tiles and stuff :)
	if event.is_action_pressed("remove_tile"):
		emit_signal("removeTile", get_global_mouse_position())
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


func _on_ammo_changed():
	ammoBar.value = GameManager.percentage_of(playerData.ammo, playerData.maxAmmo)


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
	GameManager.emit_signal("screenshake", 2, 8, .05, .05, 9)
	# Knockback
	dir += dir*playerData.kbStrength

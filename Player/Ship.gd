extends KinematicBody2D

export var maxSpeed = 300
export var accelaration = .5
export var rotationSpeed = 90

onready var camera = $Camera2D
onready var jetSmoke = $JetSmoke
onready var planetFinderAnim = $CanvasLayer/PlanetFinderAnim
onready var moveForwardSound = $Sounds/Drive
onready var planetFinder = $CanvasLayer/PlanetFinderPanel

signal changePlanetFinder(planet)

#var speed = 0.0
var vel = Vector2.ZERO


func _ready():
	for b in planetFinder.get_node("VBoxContainer").get_children():
		if b is Button:
			b.focus_mode = Control.FOCUS_NONE


func _physics_process(delta):
	# Rotating
	var rotationDir = Input.get_action_strength("move_right")-Input.get_action_strength("move_left")
	rotation_degrees += (rotationDir*rotationSpeed)*delta
	camera.global_rotation = 0
	
	# Moving
	
	# Getting the speed
	var accelDir = Input.get_action_strength("move_up")-(Input.get_action_strength("move_down")/2)
	
	if accelDir != 0:
		jetSmoke.emitting = true
		if !moveForwardSound.playing:
			moveForwardSound.play()
	else:
		jetSmoke.emitting = false
		moveForwardSound.stop()
	
	# Getting the direction
	var moveDir = Vector2.UP.rotated(rotation)*accelDir
	vel = vel.move_toward(moveDir*maxSpeed, accelaration*delta)
# warning-ignore:return_value_discarded
	move_and_slide(vel*delta)


func _input(event):
	if event.is_action_pressed("showPlanetFinder"):
		if planetFinder.rect_position.is_equal_approx(Vector2.ZERO):
			planetFinderAnim.play_backwards("show")
			return
		planetFinderAnim.play("show")


func change_planet_finder(planet):
	emit_signal("changePlanetFinder", planet)

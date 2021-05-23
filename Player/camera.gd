extends Camera2D

onready var offsetTween = $OffsetTween
onready var rotTween = $RotTween
onready var timer = $Timer


export var mouseWeight = true


# Mouse movement
var lerpSpeed = 1
var maxOffset = 32
var baseMaxOffset = maxOffset
var sensitivity = 6


# Screenshake
var priority = -1
var strength = 0
var rotStrength
var freq = 0
var time = 0
var shakeDir = Vector2.ZERO


func _ready():
# warning-ignore:return_value_discarded
	GameManager.connect("screenshake", self, "start")
	if !mouseWeight: set_process(false)


func _process(_delta):
	# Finding out where the camera should be by
	# getting the direction and distance to the mouse and
	# lerping the position to the direction*distance

	var mousePosition = get_local_mouse_position()
	var dirMouse = position.rotated(global_rotation).direction_to(mousePosition)
	var mouseDist = (position.distance_to(mousePosition)/sensitivity)*Settings.cameraLook
	mouseDist = clamp(mouseDist, -maxOffset, maxOffset)

	position = lerp(position, dirMouse*mouseDist, lerpSpeed)


# SCREENSHAKE
func start(priority_=0, strength_=16, freq_=.1, time_=.25, rotStrength_=12, dir=Vector2.ZERO):
	# Check the priority so small actions don't overtake big ones
	if priority > priority_:
		return

	# Setting the properties
	priority = priority_
	strength = strength_*Settings.screenshake
	freq = freq_
	time = time_
	shakeDir = dir
	rotStrength = rotStrength_*Settings.screenshake

	# Starting the screenshake
	if timer.is_inside_tree():
		timer.start(time)
	shake()


func shake():
	# Getting the direction
	var dir
	if shakeDir == Vector2.ZERO:
		dir = Vector2.RIGHT.rotated(rand_range(0, 360))*strength
	else:
		dir = shakeDir*strength

	# Getting the rotation
	var rot = rand_range(-rotStrength, rotStrength)
	if rot > 0: rot = rotStrength; else: rot = -rotStrength

	# Tweening the offset
	if offsetTween.is_inside_tree():
		offsetTween.interpolate_property(self, "offset", offset, dir, freq,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		offsetTween.start()

	# Tweening the rotation
	if rotTween.is_inside_tree():
		rotTween.interpolate_property(self, "rotation_degrees", rotation_degrees, rot,
		freq, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		rotTween.start()


func _on_Tween_tween_all_completed():
	# If timer is over, stop, and reset
	print(timer.time_left)
	if timer.is_stopped():
		priority = -1

		# Resetting the offset
		offsetTween.interpolate_property(self, "offset", offset, Vector2.ZERO, freq,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		offsetTween.start()

		# Resetting the rotation
		rotTween.interpolate_property(self, "rotation_degrees", rotation_degrees, 0,
		freq, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		rotTween.start()
		return
	shake()



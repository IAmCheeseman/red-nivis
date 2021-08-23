extends Camera2D

onready var offsetTween = $OffsetTween
onready var timer = $Timer

export var mouseWeight = true
export var yOffset = 0
export var limits:Rect2 = Rect2(-1000000, -1000000, 1000000, 1000000)
export var trackNodePath:NodePath

onready var trackNode = get_node(trackNodePath)

# Mouse movement
var lerpSpeed = .3
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

var playerData = preload("res://Player/Player.tres")


func _ready():
# warning-ignore:return_value_discarded
	GameManager.currentCamera = self
	GameManager.connect("screenshake", self, "start")
	if !mouseWeight: set_process(false)


func _process(delta):
	# Finding out where the camera should be by
	# getting the direction and distance to the mouse and
	# lerping the position to the direction*distance
	var mousePosition = get_local_mouse_position()
	var dirMouse = position.rotated(global_rotation).direction_to(mousePosition)
	var mouseDist = (position.distance_to(mousePosition)/sensitivity)*Settings.cameraLook
	
	global_position = trackNode.global_position+(dirMouse*mouseDist)
	
	var vs = get_viewport_rect().end*.5
	global_position.x = clamp(global_position.x, limits.position.x+vs.x, limits.end.x-vs.x)
	global_position.y = clamp(global_position.y, limits.position.y+vs.y, limits.end.y-vs.y)


func set_cam_look(value:bool):
	maxOffset = baseMaxOffset * int(value)


# SCREENSHAKE
func start(priority_=0, strength_=16, freq_=.1, time_=.25, dir=Vector2.ZERO):
	# Check the priority so small actions don't overtake big ones
	if priority >= priority_:
		return

	# Setting the properties
	priority = priority_
	strength = strength_*Settings.screenshake
	freq = freq_
	time = time_
	shakeDir = dir

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

	# Tweening the offset
	if offsetTween.is_inside_tree():
		offsetTween.interpolate_property(self, "offset", offset, dir, freq,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		offsetTween.start()


func _on_Tween_tween_all_completed():
	# If timer is over, stop, and reset
	if timer.is_stopped():
		priority = -1

		# Resetting the offset
		offsetTween.interpolate_property(self, "offset", offset, Vector2.ZERO, freq,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		offsetTween.start()

		return
	shake()


func _on_Camera_tree_exiting():
	offsetTween.remove_all()

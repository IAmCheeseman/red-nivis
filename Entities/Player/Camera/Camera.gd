extends Camera2D

onready var offsetTween = $OffsetTween
onready var timer = $Timer
onready var zoomTween = $ZoomTween
onready var posTween = $PosTween
onready var zoomTimer = $ZoomTimer
onready var smoothingTimer = $SmoothingTimer

export var mouseWeight = true
export var yOffset = 0
export var limits:Rect2 = Rect2(-1000000, -1000000, 1000000, 1000000) setget set_limits
export var trackNodePath:NodePath

onready var trackNode = get_node(trackNodePath)

# Mouse movement
var lerpSpeed = .3
var maxOffset = 32
var baseMaxOffset = maxOffset
var sensitivity = 16

# Screenshake
var priority = -1
var strength = 0
var rotStrength
var freq = 0
var time = 0
var shakeDir = Vector2.ZERO

var zoomingIn := false
var zoomTarget := Vector2.ZERO
var zoomTime := .2

var playerData = preload("res://Entities/Player/Player.tres")


func _ready():
	GameManager.currentCamera = self
	var _discard0 = GameManager.connect("screenshake", self, "start")
	var _discard1 = GameManager.connect("zoom_in", self, "zoom_in")
	
	yield(TempTimer.idle_frame(self), "timeout")
	smoothing_enabled = false


func _process(_delta):
	if !zoomingIn:
		global_position = trackNode.global_position
		
		var vs = get_viewport_rect().end*.5
		
		global_position.x = clamp(
			global_position.x,
			limits.position.x+min(vs.x, Globals.DEFAULT_CAM_SIZE.x*.5),
			limits.end.x-min(vs.x, Globals.DEFAULT_CAM_SIZE.x*.5)
		)
		global_position.y = clamp(
			global_position.y,
			limits.position.y+min(vs.y, Globals.DEFAULT_CAM_SIZE.y*.5),
			limits.end.y-min(vs.y, Globals.DEFAULT_CAM_SIZE.y*.5)
		)

		var mousePosition = Utils.get_global_mouse_position()
		var dirMouse = global_position.direction_to(mousePosition)
		var mouseDist = (global_position.distance_to(mousePosition)/sensitivity)
		mouseDist = clamp(mouseDist, -maxOffset, maxOffset)
		global_position += (dirMouse*mouseDist)*int(mouseWeight)
#		global_position.y -= 16*3
	else:
		global_position = zoomTarget 


func set_limits(val) -> void:
	limits = val
	smoothing_enabled = true
	smoothingTimer.start()


func set_cam_look(value:bool):
	maxOffset = baseMaxOffset * int(value)


func zoom_in(z:=.5, t:=2, zt:=.2, zoomPos:=global_position):
	if zoomingIn: return
	smoothing_enabled = true
	zoomTime = zt
	
	zoomTween.interpolate_property(
		self,
		"zoom",
		zoom,
		Vector2.ONE*z,
		zt,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT
	)
	
	posTween.interpolate_property(
		self,
		"global_position", 
		global_position,
		zoomPos,
		zt,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT
	)
	
	posTween.start()
	zoomTween.start()
	
	zoomTimer.start(t)
	
	zoomTarget = zoomPos
	zoomingIn = true

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


func _on_zoom_timer_timeout() -> void:
	
	smoothing_enabled = true
	smoothingTimer.start(.45)
	
	zoomTween.interpolate_property(
		self,
		"zoom",
		zoom,
		Vector2.ONE,
		zoomTime,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT
	)
	
	posTween.interpolate_property(
		self,
		"global_position", 
		global_position,
		trackNode.global_position,
		zoomTime,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT
	)
	
	posTween.start()
	zoomTween.start()
	
	zoomingIn = false

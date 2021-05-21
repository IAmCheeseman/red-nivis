extends Camera2D

onready var tween = $Tween
onready var timer = $Timer


# Mouse movement
var lerpSpeed = 1
var maxOffset = 32
var baseMaxOffset = maxOffset
var sensitivity = 6


# Screenshake
var priority = -1
var strength = 0
var freq = 0
var time = 0
var isRandom = true
var isBackwards = false


func _ready():
	GameManager.connect("screenshake", self, "start")


func _process(_delta):
	var mousePosition = get_local_mouse_position()
	var dirMouse = position.direction_to(mousePosition)
	var mouseDist = position.distance_to(mousePosition)/sensitivity
	mouseDist = clamp(mouseDist, -maxOffset, maxOffset)

	var newOffset = lerp(offset, dirMouse*mouseDist, lerpSpeed)
	offset = newOffset

# SCREENSHAKE
func start(priority_=0, strength_=16, freq_=.1, time_=.25, isRandom_=true, isBackwards_=false):
	if priority > priority_:
		return
	priority = priority_
	strength = strength_
	freq = freq_
	time = time_
	isRandom = isRandom_
	isBackwards = isBackwards_

	timer.start(time)
	if isRandom:
		shakeRandom()
	else:
		shake()


func shake():
	var shakeDir = global_position.direction_to(get_global_mouse_position())*strength
	shakeDir -= (shakeDir*2)*int(!isBackwards)

	tween.interpolate_property(self, "offset", offset, Vector2.ZERO+shakeDir, freq,
	Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	tween.start()


func shakeRandom():
	var shakeDir = Vector2.RIGHT.rotated(rand_range(0, 360))*rand_range(1, strength)
	tween.interpolate_property(self, "offset", offset, Vector2.ZERO+shakeDir, freq,
	Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	tween.start()


func _on_Tween_tween_all_completed():
	if timer.is_stopped() or !isRandom:
		priority = -1
		tween.interpolate_property(self, "offset", offset, Vector2.ZERO, freq,
		Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
		tween.start()
		return

	if isRandom:
		shakeRandom()
	else:
		shake()

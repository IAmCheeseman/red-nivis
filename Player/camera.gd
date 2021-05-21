extends Camera2D

var lerpSpeed = 1
var maxOffset = 32
var baseMaxOffset = maxOffset
var sensitivity = 6

func _process(_delta):
	var mousePosition = get_local_mouse_position()
	var dirMouse = position.direction_to(mousePosition)
	var mouseDist = position.distance_to(mousePosition)/sensitivity
	mouseDist = clamp(mouseDist, -maxOffset, maxOffset)
	
	var newOffset = lerp(offset, dirMouse*mouseDist, lerpSpeed)
	offset = newOffset


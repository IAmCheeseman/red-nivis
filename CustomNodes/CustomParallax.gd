extends Node2D
class_name CustomParallax

export var scrollSpeed:Vector2 = Vector2(1, 1)
export var infiniteScrolling:bool = true
export var cameraPath:NodePath
export var limitsStart:Vector2
export var limitsEnd:Vector2

onready var camera:Camera2D = get_node(cameraPath)


func _process(delta):
	var viewportSize:Vector2 = get_viewport_rect().end
	var newPos:Vector2 = (camera.global_position+camera.offset)-(viewportSize*.5)
	newPos *= scrollSpeed

	# Infinite scrolling
	var wraps:float = floor(newPos.x/viewportSize.x)*viewportSize.x
	newPos.x += wraps if newPos.x-wraps <= 0 else 0

	newPos.x = clamp(newPos.x, limitsStart.x, limitsEnd.x)
	newPos.y = clamp(newPos.y, limitsStart.y, limitsEnd.y)

	# Applying the final position
	global_position = newPos



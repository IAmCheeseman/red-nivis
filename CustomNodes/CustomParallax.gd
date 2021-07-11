extends Node2D
class_name CustomParallax

export var scrollSpeed:Vector2 = Vector2(1, 1)
export var infiniteScrolling:bool = true
export var cameraPath:NodePath

onready var camera = get_node(cameraPath)


func _process(delta):
	# Getting the base position
	var viewportSize = get_viewport_rect().end
	var newPos = camera.global_position-(viewportSize/2)
	newPos *= scrollSpeed

	# Infinite scrolling
	var shiftCount = floor(newPos.x/viewportSize.x)
	newPos.x += (shiftCount*viewportSize.x)

	# Applying the final position
	global_position = newPos

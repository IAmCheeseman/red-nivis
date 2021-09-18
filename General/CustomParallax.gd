extends Node2D
class_name CustomParallax

export var scrollSpeed:Vector2 = Vector2(1, 1)
export var infiniteScrolling:bool = true
export var cameraPath:NodePath
export var limitsStart:Vector2
export var limitsEnd:Vector2

onready var camera:Camera2D = get_node(cameraPath)


func _process(_delta):
	var viewportSize:Vector2 = get_viewport_rect().end
	var newPos:Vector2 = (camera.global_position+camera.offset)-(viewportSize*.5)
	newPos *= scrollSpeed

	# Applying the final position
	global_position = newPos



extends Node

var vignette = true
var cameraLook = 1
var pixelPerfect = true setget set_pixel_perfect
var screenshake = 1
var playerTilt = true


func set_pixel_perfect(value):
	pixelPerfect = value
	if pixelPerfect == true:
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, SceneTree.STRETCH_ASPECT_KEEP, Vector2(600, 600), 2)
	else:
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_KEEP, Vector2(600, 600), 2)

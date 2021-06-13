extends Control

onready var mapSprite = $ViewportContainer/Viewport/MapSprite
onready var mapIcon = $ViewportContainer/Viewport/MapSprite/MapIcon


func set_map(texture:ImageTexture):
	mapSprite.texture = texture


func set_icon_pos(pos:Vector2):
	mapIcon.position = pos/16

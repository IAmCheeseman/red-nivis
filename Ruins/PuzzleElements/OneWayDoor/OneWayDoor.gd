extends StaticBody2D
tool

export var sprite : StreamTexture setget set_texture


func set_texture(value):
	sprite = value
	$Sprite.texture = value

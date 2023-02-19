extends Node2D

export var moveAmount:float

onready var mainPosition:Vector2 = position

func _process(delta:float) -> void: 
	position = mainPosition + get_local_mouse_position() * moveAmount
	position = position.round()

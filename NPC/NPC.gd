extends Node2D

onready var sprite = $ScaleHelper/Sprite
onready var shadow = $ScaleHelper/Shadow


func _process(delta):
	shadow.frame = sprite.frame

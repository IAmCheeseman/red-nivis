extends Node2D
class_name SpeedUp

const PLAYER = preload("res://Entities/Player/Player.tres")


func _ready() -> void:
	PLAYER.speedMod += .2

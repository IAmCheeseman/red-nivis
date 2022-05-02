extends Node2D
class_name HPUp

const PLAYER = preload("res://Entities/Player/Player.tres")


func _ready() -> void:
	PLAYER.maxHealth += 1

func _exit_tree() -> void:
	PLAYER.maxHealth -= 1

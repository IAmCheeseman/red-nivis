extends Node2D

const PLAYER = preload("res://Entities/Player/Player.tres")

func _ready() -> void:
	PLAYER.kbMod += 100

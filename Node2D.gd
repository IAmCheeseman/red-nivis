extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var newBandit = preload("res://Entities/Enemies/Bandit/Shotgun/ShotgunBandit.tscn").instance()
	newBandit.global_position = Vector2(0, -100)
	add_child(newBandit)

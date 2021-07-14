extends Node2D


func _ready():
	Engine.time_scale = 1.2
	randomize()

	get_tree().change_scene("res://UI/MainMenu.tscn")

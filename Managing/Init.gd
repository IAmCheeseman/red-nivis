extends Node2D


func _ready():
	randomize()

	get_tree().change_scene("res://UI/MainMenu/MainMenu.tscn")

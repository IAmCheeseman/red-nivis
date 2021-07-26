extends Node2D


func _ready():
	randomize()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://UI/MainMenu/MainMenu.tscn")

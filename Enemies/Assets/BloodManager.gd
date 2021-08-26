extends Node2D

var blood = preload("res://Enemies/Blood.tscn")

func emit_blood(dir : Vector2):
	var newBlood = blood.instance()
	newBlood.rotation = dir.angle()
	add_child(newBlood)

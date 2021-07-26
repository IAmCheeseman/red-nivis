extends Node2D

func _ready():
	GameManager.spawnManager = self

func spawn_object(object:Node):
	add_child(object)


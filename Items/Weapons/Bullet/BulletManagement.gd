extends Node2D

func _ready():
	GameManager.spawnManager = self

func add_bullet(bullet:Node2D):
	add_child(bullet)


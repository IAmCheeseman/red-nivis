extends Node2D

onready var tileCheckers = $TileCheckers

func _ready() -> void:
	for i in tileCheckers.get_children():
		if !i.is_colliding(): queue_free()
	tileCheckers.queue_free()

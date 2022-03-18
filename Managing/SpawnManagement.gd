extends Node2D

signal spawned

func _ready():
	GameManager.spawnManager = self


func spawn_object(object:Node):
	call_deferred("add_child", object)
	emit_signal("spawned")


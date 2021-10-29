extends Node2D

export var enemiesPath:NodePath

onready var enemies = get_node(enemiesPath)

var isChecking := false

signal enemiesCleared


func _ready() -> void:
	yield(get_tree(), "idle_frame")
	if enemies.get_child_count() == 0:
		emit_signal("enemiesCleared")

func _process(_delta: float) -> void:
	if enemies.get_child_count() == 0 and isChecking:
		emit_signal("enemiesCleared")
	elif enemies.get_child_count() > 0:
		isChecking = true

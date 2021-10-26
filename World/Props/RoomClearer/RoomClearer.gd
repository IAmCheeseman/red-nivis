extends Node2D

export var enemiesPath:NodePath

onready var enemies = get_node(enemiesPath)


var enemiesLeft = 0


signal enemiesCleared


func _ready() -> void:
	yield(get_tree(), "idle_frame")
	if enemies.get_child_count() == 0:
		emit_signal("enemiesCleared")
		_on_enemy_killed()


func get_enemies() -> void:
	for e in enemies.get_children():
		enemiesLeft += 1
		if e.has_signal("death"):
			e.connect("death", self, "_on_enemy_killed")


func _on_enemy_killed(): 
	enemiesLeft -= 1
	if enemiesLeft <= 0:
		emit_signal("enemiesCleared")

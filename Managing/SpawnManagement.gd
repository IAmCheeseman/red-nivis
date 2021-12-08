extends Node2D


var shells = []


func _ready():
	GameManager.spawnManager = self


func spawn_object(object:Node):
	call_deferred("add_child", object)


func spawn_shell(shell:Node2D):
	add_child(shell)
	shells.append(shell.get_path())
	
	while shells.size() > 50:
		get_node(shells.pop_front()).queue_free()


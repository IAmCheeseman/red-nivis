extends Node2D
class_name EnemyCounter

onready var enemies = get_parent()
#export(NodePath) onready var enemies = get_node(enemies) as Node2D
export(NodePath) onready var node = get_node(node) as Node2D
var enemies_n := []

var nodeParent: Node
var nodeAdded := false


func _ready() -> void:
	for i in enemies.get_children():
		if i is KinematicBody2D:
			enemies_n.append(i)
	nodeParent = node.get_parent()
	nodeParent.call_deferred("remove_child", node)


func _process(_delta: float) -> void:
	for i in enemies_n:
		if !is_instance_valid(i):
			enemies_n.erase(i)
	if enemies_n.size() == 0:
		get_parent().add_child(node)
		nodeAdded = true
		queue_free()

func _exit_tree() -> void:
	if !nodeAdded and is_instance_valid(node):
		node.queue_free()



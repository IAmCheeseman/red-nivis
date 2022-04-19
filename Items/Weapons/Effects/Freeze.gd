extends Node
class_name FreezeEffect

var hurtbox: Area2D
var enemy: Node2D
var prevMod: Color


func _ready() -> void:
	var nodeName = ""
	enemy = hurtbox
	while nodeName.to_lower() in ["collisions", ""]:
		enemy = enemy.get_node("..")
		nodeName = enemy.name
	prevMod = enemy.modulate


func _process(delta: float) -> void:
	enemy.vel *= .9
	enemy.modulate = Color(.2, .2, 1)


func _exit_tree() -> void:
	enemy.modulate = prevMod

extends Node2D


func _ready() -> void:
	var worldPath = @"/root/World"
	if has_node(worldPath):
		var world = get_node(worldPath)
		var _discard = world.connect("added_enemies", self, "_on_enemies_added")


func _on_enemies_added(enemies: Node2D) -> void:
	for i in enemies.get_children():
		var node = i.find_node("DamageManager")
		if node: node.maxHealth *= 0.8

extends Node2D

export(NodePath) onready var player = get_node(player)

func _process(delta: float) -> void:
	for p in get_children():
		p.modulate.a = 1 - (Vector2(
			player.global_position.x, 0).distance_to(
				Vector2(
					p.global_position.x,
					0
				)
			) / 100)

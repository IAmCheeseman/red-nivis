extends Node2D


func _process(_delta: float) -> void:
	for i in get_children():
		i.look_at(GameManager.player.global_position)
		i.get_node("Sprite").flip_v = Vector2.RIGHT.rotated(i.rotation).x < 0

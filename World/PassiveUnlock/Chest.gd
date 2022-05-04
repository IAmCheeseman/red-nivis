extends Node2D


signal open




func _on_interaction() -> void:
	emit_signal("open")

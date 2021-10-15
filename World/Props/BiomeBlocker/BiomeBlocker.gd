extends Node2D


onready var anim = $AnimationPlayer


func _on_Iteraction_interaction() -> void:
	anim.play("Deny")


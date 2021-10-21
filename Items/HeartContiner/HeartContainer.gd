extends Node2D


export var player:Resource = preload("res://Entities/Player/Player.tres")


onready var anim = $AnimationPlayer


func _on_interaction() -> void:
	anim.play("Interact")


func increment_max_health():
	player.maxHealth += 1
	player.health += 1
	queue_free()

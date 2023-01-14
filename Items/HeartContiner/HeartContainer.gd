extends Node2D


export var player:Resource = preload("res://Entities/Player/Player.tres")


onready var anim = $AnimationPlayer
onready var explode = $Explode


func _on_interaction() -> void:
#	anim.play("Interact")
	increment_max_health()


func increment_max_health():
	player.maxHealth += 25
	player.health += 25
	player.emit_signal("healthChanged", Vector2.ZERO)
	
	remove_child(explode)
	get_parent().add_child(explode)
	explode.position = position-Vector2(0, 8)
	explode.emitting = true
	
	queue_free()

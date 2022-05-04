extends Node2D

onready var anim = $AnimationPlayer
onready var interactionZone = $Iteraction
onready var sprite = $Sprite
onready var standPos = $"6amPos"

signal open

func _on_interaction() -> void:
	emit_signal("open")
	interactionZone.disabled = true
	

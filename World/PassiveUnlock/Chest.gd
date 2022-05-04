extends Node2D

onready var anim = $AnimationPlayer
onready var interactionZone = $Iteraction
onready var sprite = $Sprite
onready var standPos = $"6amPos"

signal open

var opened := false

export(Array, Resource) onready var items = [
	preload("res://Items/Passives/HPUp/HPUp.tres")
].duplicate()

func _on_interaction() -> void:
	emit_signal("open")
	interactionZone.disabled = true


func open() -> void:
	if opened: return
	opened = true
	
	items.shuffle()
	
	var newPassive = preload("res://Items/Passives/DroppedPassive.tscn").instance()
	newPassive.item = items.pop_front()
	newPassive.global_position = global_position - Vector2(0, 12)
	newPassive.apply_central_impulse(Vector2(rand_range(-24, 24), -75))
	GameManager.spawnManager.spawn_object(newPassive)

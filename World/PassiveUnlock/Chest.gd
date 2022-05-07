extends Node2D

onready var anim = $AnimationPlayer
onready var interactionZone = $Iteraction
onready var sprite = $Sprite
onready var standPos = $"6amPos"

signal open

var opened := false

export(Array, Resource) var items = []


func _ready() -> void:
	var isOpened = GameManager.worldData.get_room_data(self, false)
	if isOpened:
		opened = true
		interactionZone.disabled = true
		anim.play("Open")


func _on_interaction() -> void:
	emit_signal("open")
	GameManager.worldData.store_room_data(self, true)
	interactionZone.disabled = true


func open() -> void:
	if opened: return
	opened = true
	
	items = items.duplicate()
	items.shuffle()
	
	var newPassive = preload("res://Items/Passives/DroppedPassive.tscn").instance()
	newPassive.item = items.pop_front()
	newPassive.global_position = global_position - Vector2(0, 12)
	newPassive.apply_central_impulse(Vector2(rand_range(-24, 24), -75))
	GameManager.spawnManager.spawn_object(newPassive)

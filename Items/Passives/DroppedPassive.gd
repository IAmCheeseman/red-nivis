extends RigidBody2D

onready var sprite=  $Sprite

export var item: Resource


func _ready() -> void:
	sprite.texture = item.sprite


func _on_interaction() -> void:
	var player = preload("res://Entities/Player/Player.tres")
	player.passives.append(item)
	player.playerObject.update_passives()
	
	queue_free()
